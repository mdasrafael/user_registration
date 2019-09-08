class User < ApplicationRecord
  attr_accessor :password, :not_updating_password, :not_validating_username

  before_save :encrypt_password
  after_save :clear_password

  EMAIL_REGEX = /\A[^@^\s]+@[^@^\s]+\z/
  validates :username, :presence => true, :length => { minimum: 5 }, unless: :not_validating_username
  validates :email, :presence => true, :uniqueness => true
  validates :password, :presence => true, :confirmation => true, unless: :not_updating_password
  validates_length_of :password, :in => 8..20, unless: :not_updating_password
  validates_format_of :email,
  	:with => EMAIL_REGEX

  def self.authenticate(username_or_email='', login_password='')
    if EMAIL_REGEX.match(username_or_email)
      user = User.find_by_email(username_or_email)
    else
      user = User.find_by_username(username_or_email)
    end

    if user && user.match_password(login_password)
      return user
    else
      return false
    end
  end

  def update_password_with_password(params, *options)
    current_password = params.delete('current_password')

    result = if match_password(current_password)
               update_attributes(params, *options)
             else
               self.assign_attributes(params, *options)
               self.valid?
               self.errors.add('current_password', current_password.blank? ? 'is blank' : 'is invalid')
               false
             end

    clear_password
    result
  end

  def match_password(login_password='')
    encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
  end

  def encrypt_password
    unless password.blank?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def clear_password
    self.password = nil
  end

  def generate_password_token!
    self.not_validating_username = true
    self.not_updating_password = true
    loop do
      self.reset_password_token = generate_token
      break unless User.find_by(reset_password_token: self.reset_password_token)
    end
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (self.reset_password_sent_at + 6.hours) > Time.now.utc
  end

  def reset_password!(params, *options)
    self.not_validating_username = true
    self.assign_attributes(params, *options)
    self.valid?
    unless self.errors.present?
      self.reset_password_token = nil
      save!
    else
      return false
    end
  end

  private

  def generate_token
    SecureRandom.hex(10)
  end
end

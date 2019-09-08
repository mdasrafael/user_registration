class PasswordsController < ApplicationController

  def reset
    unless confirm_token(params[:token])
      flash[:color] = 'invalid'
      redirect_back(fallback_location: forgot_password_url, notice: 'Link not valid or expired, try generating a new link')
      return
    end

    @user = User.find_by(reset_password_token: params[:token])
  end

	def create_token
    unless params[:user][:email].present?
      flash[:color] = 'invalid'
      redirect_back(fallback_location: forgot_password_url, notice: 'Please inform your email address')
      return
    end

    user = User.find_by(email: params[:user][:email])

    if user.present?
      user.generate_password_token!
      url = reset_password_url + '?token=' + user.reset_password_token
    	UserMailer.with(user: user, url: url).reset_password_email.deliver_now
      flash[:color]= 'valid'
      redirect_to login_url, notice: 'Please check your email for a link to reset your password'
    else
      flash[:color]= 'invalid'
      redirect_to forgot_password_url, notice: 'Email address not found'
    end
  end

  protected

  def confirm_token(token)
    return false unless token.present?

    token = params[:token].to_s
    user = User.find_by(reset_password_token: token)

    user.present? && user.password_token_valid? ? true : false
  end
end

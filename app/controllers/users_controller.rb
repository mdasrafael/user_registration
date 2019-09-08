class UsersController < ApplicationController
  before_action :authenticate_user, only: [:edit, :update, :destroy]
  before_action :save_login_state, only: [:new, :create]

  def new
    @user = User.new()
  end

  def create
    @user = User.new(create_params.merge(username: username, not_validating_username: true))

    if @user.save
    	UserMailer.with(user: @user, url: login_url).welcome_email.deliver_now
      session[:user_id] = @user.id
      flash[:color] = 'valid'
      redirect_to profile_url, notice: 'You signed up successfully'
    else
      flash[:color] = 'invalid'
      redirect_to signup_url, notice: @user.errors.full_messages.join(', ')
    end
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def update
    unless update_params['current_password'].present?
      flash[:color] = 'invalid'
      redirect_back(fallback_location: profile_url, notice: 'Please input your current password')
      return
    end

    @user = User.find(session[:user_id])

    if @user.update_password_with_password(update_params.merge(not_updating_password: !(update_params['password'].present? && update_params['password_confirmation'].present?)))
      flash[:color] = 'valid'
      msg = 'Successfully updated your profile'
    else
      flash[:color] = 'invalid'
      msg = @user.errors.full_messages.join(', ')
    end
    redirect_to profile_url, notice: msg
  end

  def update_password
    unless password_reset_params['password'].present? && password_reset_params['password_confirmation'].present?
      flash[:color] = 'invalid'
      redirect_back(fallback_location: reset_password_url, notice: 'Please input password and password confirmation')
      return
    end

    @user = User.find_by(reset_password_token: password_reset_params[:reset_password_token])

    if @user.reset_password!(password_reset_params)
      flash[:color] = 'valid'
      msg = 'Your password was successfully changed'
    else
      flash[:color] = 'invalid'
      msg = @user.errors.full_messages.join(', ')
    end
    redirect_to login_url, notice: msg
  end

  def destroy
    @user = User.find(session[:user_id])

    @user.destroy
    session.destroy
    flash[:color] = 'valid'
    redirect_to login_url, notice: 'Account deleted'
  end

  def username
    create_params['email'].split(/@/).first
  end

  def create_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:username, :current_password, :password, :password_confirmation)
  end

  def password_reset_params
    params.require(:user).permit(:password, :password_confirmation, :reset_password_token)
  end
end

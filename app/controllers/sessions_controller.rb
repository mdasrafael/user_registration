class SessionsController < ApplicationController
  before_action :save_login_state, only: [:new, :create]

  def create
    authorized_user = User.authenticate(params[:username_or_email], params[:login_password])

    if authorized_user
      session[:user_id] = authorized_user.id
      flash[:color]= 'valid'
      redirect_to profile_url, notice: 'Successfully signed in'
    else
      flash[:color]= 'invalid'
      redirect_to login_url, notice: 'Invalid Username or Password'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url
  end
end

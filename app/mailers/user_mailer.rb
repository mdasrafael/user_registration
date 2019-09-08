class UserMailer < ApplicationMailer
  default from: 'notifications@incubit.co.jp'

  def welcome_email
    @user = params[:user]
    @url  = params[:url]
    mail(to: @user.email, subject: 'Welcome to incubit!')
  end

  def reset_password_email
    @user = params[:user]
    @url  = params[:url]
    mail(to: @user.email, subject: 'Complete your password reset request')
  end
end

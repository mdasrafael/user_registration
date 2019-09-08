class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

  def authenticate_user
    if session[:user_id]
	    @current_user = User.find session[:user_id]
	    return true
	  else
	    redirect_to login_url
	    return false
	  end
  end

  def save_login_state
    if session[:user_id]
      redirect_to profile_url
      return false
    else
      return true
    end
  end
end

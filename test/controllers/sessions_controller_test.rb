require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include FactoryBot::Syntax::Methods

  test "should create" do
  	user = create(:user)
    assert_difference(session[:user_id]) do
	  	post :create, params: {
	  		    username_or_email: user.username,
	          login_password: 'easyplease'
	        }
    end
    assert_redirected_to :profile
  end

  test "should delete" do
    user = create(:user)
  	post :create, params: {
  		    username_or_email: user.username,
          login_password: 'easyplease'
        }
    get :destroy
    assert_nil(session[:user_id])
  end

end

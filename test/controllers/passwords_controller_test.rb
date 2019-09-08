require 'test_helper'

class PasswordsControllerTest < ActionController::TestCase
  include FactoryBot::Syntax::Methods

  test "should create password reset token" do
    user = create(:user)
    assert_difference(user.reset_password_token) do
	  	post :create_token, params: { user: {
	  		    email: user.username
	        } }
    end
  end

  test "should confirm password reset token" do
    user = create(:user)
    assert_difference(user.reset_password_token) do
	  	post :reset, params: {
	  		    token: user.reset_password_token
	        }
    end
  end

  test "should reject expired password reset token" do
    user = create(:user_with_old_reset_password_token)
  	post :reset, params: {
  				token: user.reset_password_token
        }
    assert_redirected_to :forgot_password
  end
end

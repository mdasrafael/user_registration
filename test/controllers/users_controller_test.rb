require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include FactoryBot::Syntax::Methods

  test 'should get signup' do
    get :new
    assert_response 200
    assert_match(/signup/, response.body)
  end

  test 'should redirect when there is no session' do
    get :edit
    assert_response 302
    assert_match(/login/, response.body)
  end

  test 'should register new user' do
    assert_difference(session[:user_id]) do
	  	post :create, params: { user: {
	          email: 'user@example.com',
	          password: 'easyplease',
	          password_confirmation: 'easyplease'
	        } }
    end
  end

  test 'should get profile' do
  	post :create, params: { user: {
          email: 'user@example.com',
          password: 'easyplease',
          password_confirmation: 'easyplease'
        } }
    assert_response 302
    assert_match(/profile/, response.body)
  end
end

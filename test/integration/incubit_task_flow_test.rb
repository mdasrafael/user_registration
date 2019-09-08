require 'test_helper'

class IncubitTaskFlowTest < ActionDispatch::IntegrationTest
  include FactoryBot::Syntax::Methods

  test 'should send welcome email' do
  	# 1. As a user, I can visit sign up page and sign up with my email (with valid format
  	# and unique in database) and password (with confirmation and at least eight characters).
    get '/signup'
    assert_response 200
    assert_match(/signup/, response.body)

    # 2. When I sign up successfully, I would see my profile page.
  	post '/users', params: { user: {
          email: 'user@example.com',
          password: 'easyplease',
          password_confirmation: 'easyplease'
        } }
    assert_response 302
    assert_match(/profile/, response.body)

    # 6. When I first time entering the page, my username would be my email prefixing,
    # e.g. (email is “user@example.com” , username would be “user”)
    assert_equal(User.first.username, User.first.email.split(/@/).first)

    # 3. When I sign up successfully, I would receive a welcome email.
    @user = User.first
    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal(@user.email, ActionMailer::Base.deliveries.last.to.first)
    assert_match('Welcome to incubit!', ActionMailer::Base.deliveries.last.subject)

    # 5. As a user, I can edit my username and password in profile page.
    # I can also see my email in the page but I can not edit it.
    put '/update_profile', params: { user: {
          username: 'user123',
          email: 'test@test.com',
          current_password: 'easyplease',
          password: 'easy1234',
          password_confirmation: 'easy1234'
        } }
    assert_not_equal(User.first.username, @user.username)
    assert_not_equal(User.first.encrypted_password, @user.encrypted_password)
    assert_equal(User.first.email, @user.email)

    # 7. When I edit my username, it should contain at least five characters.
    # (Default username does not has this limitation)
    put '/update_profile', params: { user: {
          username: 'user'
        } }
    assert_redirected_to('/profile', notice: 'Username is too short (minimum is 5 characters)')

    # 8. As a user, I can log out the system.
    get '/logout'
    assert_not(session[:user_id].present?)


    # 9. When I log out, I would see the login page.
    assert_redirected_to('/login')

    # 10. As a user, I can visit login page and click “forgot password” if I forgot my password
    get '/login'
    assert_match(/Forgot your password?/, response.body)

    # 11. When I visit forgot password page, I can fill my email and ask the system to send
    # reset password email.
    travel_to 1.day.ago do
	    get '/forgot_password'
	    assert_difference(User.first.reset_password_token) do
		  	post '/create_token', params: { user: {
		  		    email: @user.email
		        } }
	    end
	  end
    ActionMailer::Base.deliveries = []
    email = UserMailer.with(user: @user, url: :reset_password_url).reset_password_email.deliver_now
    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal(@user.email, ActionMailer::Base.deliveries.last.to.first)
    assert_match(email.subject, ActionMailer::Base.deliveries.last.subject)

    # 14. The link should be unique and only valid within six hours.
    get '/reset_password'
    @user = User.first
    put '/update_password', params: { user: {
    	    password: '12345678',
    	    password_confirmation: '12345678',
          reset_password_token: @user.reset_password_token
        } }
    assert_redirected_to('/login', notice: 'Link not valid or expired, try generating a new link')

    # 13. As a user, I can visit reset password page from the link inside reset password email
    # and reset my password (with confirmation and at least eight characters).
  	post '/create_token', params: { user: {
	    email: @user.username
    } }
    @user = User.first
    put '/update_password', params: { user: {
    	    password: '12345678',
    	    password_confirmation: '12345678',
          reset_password_token: @user.reset_password_token
        } }
    assert_not_equal(User.first.encrypted_password, @user.encrypted_password)

    # 4. When I sign up incorrectly, I would see error message in sign up page.
  	post '/sessions', params: {
  		    username_or_email: @user.username,
          login_password: @user.encrypted_password
        }
    assert_redirected_to('/login', notice: 'Invalid Username or Password')

    # 10. As a user, I can visit login page and login with my email and password.
    assert_difference(session[:user_id]) do
	  	post '/sessions', params: {
	  		    username_or_email: @user.username,
	          login_password: '12345678'
	        }
    end
    assert_redirected_to :profile
  end
end
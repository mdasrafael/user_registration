require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  include FactoryBot::Syntax::Methods

  test 'should send welcome email' do
  	user = create(:user)

    ActionMailer::Base.deliveries = []
    email = UserMailer.with(user: user, url: :login_url).welcome_email.deliver_now
    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal(user.email, ActionMailer::Base.deliveries.last.to.first)
    assert_match(email.subject, ActionMailer::Base.deliveries.last.subject)
  end

  test 'should send reset password email' do
    user = create(:user)

    ActionMailer::Base.deliveries = []
    email = UserMailer.with(user: user, url: :reset_password_url).reset_password_email.deliver_now
    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal(user.email, ActionMailer::Base.deliveries.last.to.first)
    assert_match(email.subject, ActionMailer::Base.deliveries.last.subject)
  end
end

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  test 'should auth' do
    user = create(:user)
    assert_equal(User.count, 1)
    assert(User.authenticate(user.username, 'easyplease'))
    assert_not(User.authenticate(user.username, ''))
  end

  test "should delete" do
    user = create(:user)
    assert_equal(User.count, 1)
    user.destroy
    assert_equal(User.count, 0)
  end
end

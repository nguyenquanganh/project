require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users :michael
    remember(@user)
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attributes remember_digest: User.digest(User.new_token)
    assert_nil current_user
  end
end
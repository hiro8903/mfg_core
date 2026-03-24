require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "strips whitespace from user_code" do
    user = User.new(user_code: "  M001  ", name: "田中 太郎", password: "password")
    user.valid?
    assert_equal "M001", user.user_code
  end
end

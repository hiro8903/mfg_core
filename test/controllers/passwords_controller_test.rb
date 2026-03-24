require "test_helper"

# [注記] パスワードリセット機能は現在の設計（user_code 認証）では未実装。
#        email_address を使った自動生成テストは無効化し、実装時に再設計する。
class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    skip "Password reset via email is not yet implemented in this design."
  end

  test "create" do
    skip "Password reset via email is not yet implemented in this design."
  end

  test "create for an unknown user redirects but sends no mail" do
    skip "Password reset via email is not yet implemented in this design."
  end

  test "edit" do
    skip "Password reset via email is not yet implemented in this design."
  end

  test "edit with invalid password reset token" do
    skip "Password reset via email is not yet implemented in this design."
  end

  test "update" do
    skip "Password reset via email is not yet implemented in this design."
  end

  test "update with non matching passwords" do
    skip "Password reset via email is not yet implemented in this design."
  end
end

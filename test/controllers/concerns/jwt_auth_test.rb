require "test_helper"

class JwtAuthTest < ActionDispatch::IntegrationTest
  include JwtAuth

  setup do
    @user = users(:one)
  end

  test "#verify_jwt! should accept valid tokens" do
    get root_url, headers: { 'Authorization': @user.token }
    auth = verify_jwt
    assert_equal auth[:user], @user
    assert_nil auth[:error]
  end

  test "#verify_jwt! should reject invalid tokens" do
    get root_url, headers: { 'Authorization': "xxxx" }
    auth = verify_jwt
    assert_nil auth[:user]
    assert_equal auth[:error], "invalid token"
  end

  test "#verify_jwt! should reject expired tokens" do
    expired_token = @user.token(-1)

    get root_url, headers: { 'Authorization': expired_token }
    auth = verify_jwt
    assert_nil auth[:user]
    assert_equal auth[:error], "expired token"
  end

  test "#verify_jwt! should reject token if user is not found" do
    token = @user.token
    @user.destroy

    get root_url, headers: { 'Authorization': token }
    auth = verify_jwt
    assert_nil auth[:user]
    assert_equal auth[:error], "user not found"
  end
end

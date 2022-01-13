require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should login with valid credentials" do
    post auth_login_url, params: { email: @user.email, password: "secret" }
    assert_response :success
    token = json_response["access_token"]
    assert_not_nil token
    payload = JWT.decode token, Rails.application.credentials[:secret_key_base]
    assert_equal payload.first["id"], @user.id
  end

  test "should not login with invalid credentials" do
    post auth_login_url, params: { email: @user.email, password: "wrong-password" }
    assert_response :unauthorized
    assert_nil json_response["access_token"]
    assert_equal json_response["error"], "Invalid email/password"

    post auth_login_url, params: { email: "some-email@gmail.com", password: "secret" }
    assert_response :unauthorized
    assert_nil json_response["access_token"]
    assert_equal json_response["error"], "Invalid email/password"
  end
end

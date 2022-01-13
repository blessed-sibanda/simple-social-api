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

  test "should get authenticated user's details" do
    get auth_profile_url, headers: auth_headers_for(@user), as: :json

    assert_equal json_response["id"], @user.id
    assert_equal json_response["name"], @user.name
    assert_equal json_response["email"], @user.email
    assert_equal_datetime "created_at", @user.created_at
    assert_equal_datetime "updated_at", @user.updated_at
  end

  test "should not get authenticated user's details if unauthenticated" do
    get auth_profile_url, as: :json
    assert_response :unauthorized
  end

  test "should revoke token when logging out" do
    token = @user.token
    delete auth_logout_url, headers: { 'Authorization': token }
    get auth_profile_url, headers: { 'Authorization': token }
    assert_response :unauthorized
    assert_equal json_response["error"], "revoked token"
  end
end

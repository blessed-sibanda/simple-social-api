require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url, as: :json
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { email: "test@example.com", name: @user.name, password: "secret", password_confirmation: "secret" }, as: :json
    end

    assert_response :created
  end

  test "should show user" do
    get user_url(@user), as: :json, headers: auth_headers_for(@user)
    assert_response :success
  end

  test "should not show user if unauthenticated" do
    get user_url(@user), as: :json
    assert_response :unauthorized
  end

  test "should update user" do
    patch user_url(@user), params: { email: @user.email, name: @user.name, password: "secret", password_confirmation: "secret" }, as: :json,
                           headers: auth_headers_for(@user)
    assert_response :success
  end

  test "should not update user if unauthenticated" do
    patch user_url(@user), params: { email: @user.email, name: @user.name, password: "secret", password_confirmation: "secret" }, as: :json
    assert_response :unauthorized
  end

  test "should not update other user's profile" do
    patch user_url(@user), params: { email: @user.email, name: @user.name, password: "secret", password_confirmation: "secret" }, as: :json,
                           headers: auth_headers_for(users(:two))
    assert_response :forbidden
    assert_equal json_response["error"], "not authorized"
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete user_url(@user), as: :json, headers: auth_headers_for(@user)
    end

    assert_response :no_content
  end

  test "should not destroy user if unauthenticated" do
    delete user_url(@user), as: :json
    assert_response :unauthorized
  end

  test "should not destroy another user's profile" do
    delete user_url(@user), as: :json, headers: auth_headers_for(users(:two))
    assert_response :forbidden
    assert_equal json_response["error"], "not authorized"
  end
end

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user attributes must not be blank" do
    user = User.new
    assert user.invalid?
    assert user.errors[:name].any?
    assert user.errors[:email].any?
    assert user.errors[:password].any?
  end

  def new_user(email, password = "secret")
    User.new(
      name: "Blessed",
      email: email,
      password: password,
    )
  end

  test "email address must be valid" do
    ok = ["ble@example.com", "gugu.ncube@gmail.com"]
    bad = ["ble", "blegmail.com", "gugu@@gmail.c"]

    ok.each do |email|
      assert new_user(email).valid?, "#{email} should be valid"
    end

    bad.each do |email|
      assert new_user(email).invalid?, "#{email} shouldn't be valid"
    end
  end

  test "email should be unique" do
    user1 = new_user("test@example.com")
    assert user1.valid?

    user2 = new_user(users(:one).email)
    assert user2.invalid?

    user3 = new_user(users(:one).email.upcase)
    assert user3.invalid?

    user4 = new_user(users(:one).email.capitalize)
    assert user4.invalid?
  end

  test "password must be at least 6 characters" do
    user1 = new_user("john@example.com", "12245")
    assert user1.invalid?
    assert user1.errors[:password].any?

    user2 = new_user("john@example.com", "123456")
    assert user2.valid?
  end
end

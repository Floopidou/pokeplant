require "test_helper"

class UserTest < ActiveSupport::TestCase
  def valid_user
    User.new(email: "test@example.com", password: "password123", password_confirmation: "password123")
  end

  test "valid with email and password" do
    assert valid_user.valid?
  end

  test "invalid without email" do
    user = valid_user
    user.email = nil
    assert_not user.valid?
  end

  test "invalid with duplicate email" do
    valid_user.save!
    duplicate = valid_user
    assert_not duplicate.valid?
  end

  test "invalid without password" do
    user = valid_user
    user.password = nil
    assert_not user.valid?
  end

  test "leaf_coins defaults to 0" do
    user = valid_user
    user.valid?
    assert_equal 0, user.leaf_coins
  end

  test "leaf_coins keeps existing value if set" do
    user = valid_user
    user.leaf_coins = 42
    user.valid?
    assert_equal 42, user.leaf_coins
  end

  test "has many plants" do
    assert_respond_to valid_user, :plants
  end

  test "has many chats" do
    assert_respond_to valid_user, :chats
  end
end

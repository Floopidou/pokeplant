require "test_helper"

class MessageTest < ActiveSupport::TestCase
  def setup
    user = User.create!(
      email: "messenger@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    plant = Plant.create!(
      user: user,
      avatar_img: "rose.png",
      position_in_garden: 3,
      nickname: "Rosa",
      common_name: "Rose",
      light_need: 9,
      toxicity: 1,
      temperature_min: 0.0,
      temperature_max: 38.0,
      ideal_pot_size: "medium",
      plant_size: "medium",
      personality: "majesty",
      last_repot: Date.today,
      last_watered: Date.today,
      input_date: Date.today
    )
    @chat = Chat.create!(user: user, plant: plant)
  end

  def valid_message
    Message.new(chat: @chat, role: "user", content: "Bonjour !")
  end

  test "valid with chat, role and content" do
    assert valid_message.valid?
  end

  test "invalid without chat" do
    msg = valid_message
    msg.chat = nil
    assert_not msg.valid?
    assert msg.errors[:chat].any?
  end

  test "invalid without role" do
    msg = valid_message
    msg.role = nil
    assert_not msg.valid?
    assert msg.errors[:role].any?
  end

  test "invalid without content" do
    msg = valid_message
    msg.content = nil
    assert_not msg.valid?
    assert msg.errors[:content].any?
  end

  test "role can be user" do
    msg = valid_message
    msg.role = "user"
    assert msg.valid?
  end

  test "role can be assistant" do
    msg = valid_message
    msg.role = "assistant"
    assert msg.valid?
  end
end

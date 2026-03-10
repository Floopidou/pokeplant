require "test_helper"

class ChatTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      email: "chatter@example.com",
      password: "password123",
      password_confirmation: "password123",
      username: "testuser",
      birthdate: Date.new(1990, 1, 1)
    )
    @plant = Plant.create!(
      user: @user,
      avatar_img: "monstera.png",
      position_in_garden: 2,
      nickname: "Monty",
      common_name: "Monstera",
      scientific_name: "Monstera deliciosa",
      light_need: 6,
      toxicity: 3,
      temperature_min: 15.0,
      temperature_max: 35.0,
      ideal_pot_size: "large",
      plant_size: "large",
      personality: "diva",
      personality_tags: "dramatic,bold,lush",
      type_of_soil: "well-draining potting mix",
      optimal_placement: "bright indirect light",
      origin_region: "Central America",
      description: "A dramatic plant with large fenestrated leaves.",
      watering_interval: 7,
      repot_interval: 365,
      last_repot: Date.today,
      last_watered: Date.today,
      input_date: Date.today
    )
  end

  def valid_chat
    Chat.new(user: @user, plant: @plant)
  end

  test "valid with user and plant" do
    assert valid_chat.valid?
  end

  test "invalid without user" do
    chat = valid_chat
    chat.user = nil
    assert_not chat.valid?
    assert chat.errors[:user].any?
  end

  test "invalid without plant" do
    chat = valid_chat
    chat.plant = nil
    assert_not chat.valid?
    assert chat.errors[:plant].any?
  end

  test "has many messages" do
    assert_respond_to valid_chat, :messages
  end
end

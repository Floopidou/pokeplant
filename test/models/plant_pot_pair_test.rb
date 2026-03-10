require "test_helper"

class PlantPotPairTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      email: "gardener@example.com",
      password: "password123",
      password_confirmation: "password123",
      username: "testuser",
      birthdate: Date.new(1990, 1, 1)
    )
    @plant = Plant.create!(
      user: @user,
      avatar_img: "fern.png",
      position_in_garden: 1,
      nickname: "Fernsy",
      common_name: "Fern",
      scientific_name: "Nephrolepis exaltata",
      light_need: 5,
      toxicity: 0,
      temperature_min: 10.0,
      temperature_max: 30.0,
      ideal_pot_size: "medium",
      plant_size: "medium",
      personality: "gentle",
      personality_tags: "soft,lush,peaceful",
      type_of_soil: "moist peat-based mix",
      optimal_placement: "indirect light, humid room",
      origin_region: "Tropical regions worldwide",
      description: "A classic fern with delicate fronds that loves humidity.",
      watering_interval: 3,
      repot_interval: 365,
      last_repot: Date.today,
      last_watered: Date.today,
      input_date: Date.today
    )
    @pot = Pot.create!(
      pot_size: "medium",
      color: "white",
      pot_img: "white_pot.png",
      leaf_coin_value: 15
    )
  end

  def valid_pair
    PlantPotPair.new(plant: @plant, pot: @pot, equipped: true)
  end

  test "valid with plant, pot and equipped" do
    assert valid_pair.valid?
  end

  test "invalid without plant" do
    pair = valid_pair
    pair.plant = nil
    assert_not pair.valid?
    assert pair.errors[:plant].any?
  end

  test "invalid without pot" do
    pair = valid_pair
    pair.pot = nil
    assert_not pair.valid?
    assert pair.errors[:pot].any?
  end

  test "invalid without equipped" do
    pair = valid_pair
    pair.equipped = nil
    assert_not pair.valid?
    assert pair.errors[:equipped].any?
  end

  test "equipped can be true" do
    pair = valid_pair
    pair.equipped = true
    assert pair.valid?
  end
end

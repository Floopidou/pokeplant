require "test_helper"

class PlantTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      email: "planter@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  def valid_attributes
    {
      user: @user,
      avatar_img: "cactus.png",
      position_in_garden: 1,
      nickname: "Spike",
      common_name: "Cactus",
      light_need: 8,
      toxicity: 2,
      temperature_min: 5.0,
      temperature_max: 40.0,
      ideal_pot_size: "small",
      plant_size: "small",
      personality: "bucolic",
      last_repot: Date.today,
      last_watered: Date.today,
      input_date: Date.today
    }
  end

  def valid_plant
    Plant.new(valid_attributes)
  end

  # --- Valeurs par défaut ---

  test "mood_points defaults to 100" do
    plant = valid_plant
    plant.valid?
    assert_equal 100, plant.mood_points
  end

  test "mood_points keeps existing value if set" do
    plant = valid_plant
    plant.mood_points = 55
    plant.valid?
    assert_equal 55, plant.mood_points
  end

  test "input_date defaults to today" do
    plant = Plant.new(valid_attributes.except(:input_date))
    plant.valid?
    assert_equal Date.today, plant.input_date
  end

  test "last_repot defaults to today" do
    plant = Plant.new(valid_attributes.except(:last_repot))
    plant.valid?
    assert_equal Date.today, plant.last_repot
  end

  test "last_watered defaults to today" do
    plant = Plant.new(valid_attributes.except(:last_watered))
    plant.valid?
    assert_equal Date.today, plant.last_watered
  end

  # --- Validations présence ---

  test "valid with all required fields" do
    assert valid_plant.valid?
  end

  %i[user avatar_img position_in_garden nickname common_name
     light_need toxicity temperature_min temperature_max
     ideal_pot_size plant_size personality].each do |attr|
    test "invalid without #{attr}" do
      plant = Plant.new(valid_attributes.except(attr))
      assert_not plant.valid?, "Expected plant to be invalid without #{attr}"
      assert plant.errors[attr].any?
    end
  end

  # --- Inclusions mood_points ---

  test "mood_points must be between 0 and 100" do
    plant = valid_plant
    plant.mood_points = 101
    assert_not plant.valid?
    assert plant.errors[:mood_points].any?
  end

  test "mood_points can be 0" do
    plant = valid_plant
    plant.mood_points = 0
    assert plant.valid?
  end

  test "mood_points can be 100" do
    plant = valid_plant
    plant.mood_points = 100
    assert plant.valid?
  end

  # --- Inclusions light_need / toxicity ---

  test "light_need must be between 0 and 10" do
    plant = valid_plant
    plant.light_need = 11
    assert_not plant.valid?
  end

  test "toxicity must be between 0 and 10" do
    plant = valid_plant
    plant.toxicity = -1
    assert_not plant.valid?
  end

  # --- Inclusions temperatures ---

  test "temperature_min must be between -20 and 100" do
    plant = valid_plant
    plant.temperature_min = -21
    assert_not plant.valid?
  end

  test "temperature_max must be between -20 and 100" do
    plant = valid_plant
    plant.temperature_max = 101
    assert_not plant.valid?
  end

  # --- Inclusions ideal_pot_size / plant_size ---

  test "ideal_pot_size must be a valid value" do
    plant = valid_plant
    plant.ideal_pot_size = "giant"
    assert_not plant.valid?
  end

  test "plant_size must be a valid value" do
    plant = valid_plant
    plant.plant_size = "tiny"
    assert_not plant.valid?
  end

  %w[small medium large very_large tree].each do |size|
    test "ideal_pot_size accepts #{size}" do
      plant = valid_plant
      plant.ideal_pot_size = size
      plant.plant_size = size
      assert plant.valid?
    end
  end

  # --- Inclusion personality ---

  test "personality must be a valid value" do
    plant = valid_plant
    plant.personality = "grumpy"
    assert_not plant.valid?
  end

  %w[bucolic partygoer rustic vacationer assistant guide inspector
     rescuer choosy diva gentle majesty artist clumsy pilferer troublemaker].each do |p|
    test "personality accepts #{p}" do
      plant = valid_plant
      plant.personality = p
      assert plant.valid?
    end
  end

  # --- Dates dans le passé ---

  test "last_repot cannot be in the future" do
    plant = valid_plant
    plant.last_repot = Date.tomorrow
    assert_not plant.valid?
    assert plant.errors[:last_repot].any?
  end

  test "last_watered cannot be in the future" do
    plant = valid_plant
    plant.last_watered = Date.tomorrow
    assert_not plant.valid?
    assert plant.errors[:last_watered].any?
  end

  test "last_repot can be today" do
    plant = valid_plant
    plant.last_repot = Date.today
    assert plant.valid?
  end

  # --- Associations ---

  test "has many plantpotpairs" do
    assert_respond_to valid_plant, :plantpotpairs
  end

  test "has many chats" do
    assert_respond_to valid_plant, :chats
  end
end

require "test_helper"

class PotTest < ActiveSupport::TestCase
  def valid_pot
    Pot.new(pot_size: "medium", color: "terracotta", pot_img: "terracotta.png", leaf_coin_value: 20)
  end

  test "valid with all required fields" do
    assert valid_pot.valid?
  end

  %i[pot_size color pot_img leaf_coin_value].each do |attr|
    test "invalid without #{attr}" do
      pot = valid_pot
      pot.send(:"#{attr}=", nil)
      assert_not pot.valid?
      assert pot.errors[attr].any?
    end
  end

  test "pot_size must be a valid value" do
    pot = valid_pot
    pot.pot_size = "giant"
    assert_not pot.valid?
    assert pot.errors[:pot_size].any?
  end

  %w[small medium large very_large tree].each do |size|
    test "pot_size accepts #{size}" do
      pot = valid_pot
      pot.pot_size = size
      assert pot.valid?
    end
  end

  test "has many plantpotpairs" do
    assert_respond_to valid_pot, :plantpotpairs
  end
end

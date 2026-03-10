require "test_helper"

class PlantPotPairsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get plant_pot_pairs_create_url
    assert_response :success
  end

  test "should get destroy" do
    get plant_pot_pairs_destroy_url
    assert_response :success
  end
end

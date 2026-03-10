require "test_helper"

class PotsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pots_index_url
    assert_response :success
  end

  test "should get show" do
    get pots_show_url
    assert_response :success
  end
end

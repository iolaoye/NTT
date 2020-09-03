require 'test_helper'

class TiledrainsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tiledrain = tiledrains(:one)
  end

  test "should get index" do
    get tiledrains_url
    assert_response :success
  end

  test "should get new" do
    get new_tiledrain_url
    assert_response :success
  end

  test "should create tiledrain" do
    assert_difference('Tiledrain.count') do
      post tiledrains_url, params: { tiledrain: {  } }
    end

    assert_redirected_to tiledrain_url(Tiledrain.last)
  end

  test "should show tiledrain" do
    get tiledrain_url(@tiledrain)
    assert_response :success
  end

  test "should get edit" do
    get edit_tiledrain_url(@tiledrain)
    assert_response :success
  end

  test "should update tiledrain" do
    patch tiledrain_url(@tiledrain), params: { tiledrain: {  } }
    assert_redirected_to tiledrain_url(@tiledrain)
  end

  test "should destroy tiledrain" do
    assert_difference('Tiledrain.count', -1) do
      delete tiledrain_url(@tiledrain)
    end

    assert_redirected_to tiledrains_url
  end
end

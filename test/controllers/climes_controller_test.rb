require 'test_helper'

class ClimesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @clime = climes(:one)
  end

  test "should get index" do
    get climes_url
    assert_response :success
  end

  test "should get new" do
    get new_clime_url
    assert_response :success
  end

  test "should create clime" do
    assert_difference('Clime.count') do
      post climes_url, params: { clime: { daily_weather: @clime.daily_weather, field_id: @clime.field_id } }
    end

    assert_redirected_to clime_url(Clime.last)
  end

  test "should show clime" do
    get clime_url(@clime)
    assert_response :success
  end

  test "should get edit" do
    get edit_clime_url(@clime)
    assert_response :success
  end

  test "should update clime" do
    patch clime_url(@clime), params: { clime: { daily_weather: @clime.daily_weather, field_id: @clime.field_id } }
    assert_redirected_to clime_url(@clime)
  end

  test "should destroy clime" do
    assert_difference('Clime.count', -1) do
      delete clime_url(@clime)
    end

    assert_redirected_to climes_url
  end
end

require 'test_helper'

class CountiesControllerTest < ActionController::TestCase
  setup do
    @county = counties(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:counties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create county" do
    assert_difference('County.count') do
      post :create, county: { county_code: @county.county_code, county_name: @county.county_name, latitude: @county.latitude, longitude: @county.longitude, state_id: @county.state_id, status: @county.status }
    end

    assert_redirected_to county_path(assigns(:county))
  end

  test "should show county" do
    get :show, id: @county
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @county
    assert_response :success
  end

  test "should update county" do
    put :update, id: @county, county: { county_code: @county.county_code, county_name: @county.county_name, latitude: @county.latitude, longitude: @county.longitude, state_id: @county.state_id, status: @county.status }
    assert_redirected_to county_path(assigns(:county))
  end

  test "should destroy county" do
    assert_difference('County.count', -1) do
      delete :destroy, id: @county
    end

    assert_redirected_to counties_path
  end
end

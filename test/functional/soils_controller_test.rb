require 'test_helper'

class SoilsControllerTest < ActionController::TestCase
  setup do
    @soil = soils(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:soils)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create soil" do
    assert_difference('Soil.count') do
      post :create, soil: { albedo: @soil.albedo, drainage_type: @soil.drainage_type, field_id: @soil.field_id, group: @soil.group, key: @soil.key, name: @soil.name, percentage: @soil.percentage, selected: @soil.selected, slope: @soil.slope, symbol: @soil.symbol }
    end

    assert_redirected_to soil_path(assigns(:soil))
  end

  test "should show soil" do
    get :show, id: @soil
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @soil
    assert_response :success
  end

  test "should update soil" do
    put :update, id: @soil, soil: { albedo: @soil.albedo, drainage_type: @soil.drainage_type, field_id: @soil.field_id, group: @soil.group, key: @soil.key, name: @soil.name, percentage: @soil.percentage, selected: @soil.selected, slope: @soil.slope, symbol: @soil.symbol }
    assert_redirected_to soil_path(assigns(:soil))
  end

  test "should destroy soil" do
    assert_difference('Soil.count', -1) do
      delete :destroy, id: @soil
    end

    assert_redirected_to soils_path
  end
end

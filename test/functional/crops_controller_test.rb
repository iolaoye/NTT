require 'test_helper'

class CropsControllerTest < ActionController::TestCase
  setup do
    @crop = crops(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:crops)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create crop" do
    assert_difference('Crop.count') do
      post :create, crop: { bushel_weight: @crop.bushel_weight, code: @crop.code, conversion_factor: @crop.conversion_factor, dd: @crop.dd, dndc: @crop.dndc, dry_matter: @crop.dry_matter, dyam: @crop.dyam, harvest_code: @crop.harvest_code, heat_units: @crop.heat_units, itil: @crop.itil, lu_number: @crop.lu_number, name: @crop.name, number: @crop.number, plant_population_ac: @crop.plant_population_ac, plant_population_ft: @crop.plant_population_ft, plant_population_mt: @crop.plant_population_mt, planting_code: @crop.planting_code, soil_group_a: @crop.soil_group_a, soil_group_b: @crop.soil_group_b, soil_group_c: @crop.soil_group_c, soil_group_d: @crop.soil_group_d, spanish_name: @crop.spanish_name, state_id: @crop.state_id, tb: @crop.tb, to1: @crop.to1, type: @crop.type, yield_unit: @crop.yield_unit }
    end

    assert_redirected_to crop_path(assigns(:crop))
  end

  test "should show crop" do
    get :show, id: @crop
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @crop
    assert_response :success
  end

  test "should update crop" do
    put :update, id: @crop, crop: { bushel_weight: @crop.bushel_weight, code: @crop.code, conversion_factor: @crop.conversion_factor, dd: @crop.dd, dndc: @crop.dndc, dry_matter: @crop.dry_matter, dyam: @crop.dyam, harvest_code: @crop.harvest_code, heat_units: @crop.heat_units, itil: @crop.itil, lu_number: @crop.lu_number, name: @crop.name, number: @crop.number, plant_population_ac: @crop.plant_population_ac, plant_population_ft: @crop.plant_population_ft, plant_population_mt: @crop.plant_population_mt, planting_code: @crop.planting_code, soil_group_a: @crop.soil_group_a, soil_group_b: @crop.soil_group_b, soil_group_c: @crop.soil_group_c, soil_group_d: @crop.soil_group_d, spanish_name: @crop.spanish_name, state_id: @crop.state_id, tb: @crop.tb, to1: @crop.to1, type: @crop.type, yield_unit: @crop.yield_unit }
    assert_redirected_to crop_path(assigns(:crop))
  end

  test "should destroy crop" do
    assert_difference('Crop.count', -1) do
      delete :destroy, id: @crop
    end

    assert_redirected_to crops_path
  end
end

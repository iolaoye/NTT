require 'test_helper'

class ResultsControllerTest < ActionController::TestCase
  setup do
    @result = results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create result" do
    assert_difference('Result.count') do
      post :create, result: { description: @result.description, detailed: @result.detailed, field_id: @result.field_id, scenario_id: @result.scenario_id, soil_id: @result.soil_id, spanish_description: @result.spanish_description, units: @result.units, value: @result.value, watershed_id: @result.watershed_id }
    end

    assert_redirected_to result_path(assigns(:result))
  end

  test "should show result" do
    get :show, id: @result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @result
    assert_response :success
  end

  test "should update result" do
    put :update, id: @result, result: { description: @result.description, detailed: @result.detailed, field_id: @result.field_id, scenario_id: @result.scenario_id, soil_id: @result.soil_id, spanish_description: @result.spanish_description, units: @result.units, value: @result.value, watershed_id: @result.watershed_id }
    assert_redirected_to result_path(assigns(:result))
  end

  test "should destroy result" do
    assert_difference('Result.count', -1) do
      delete :destroy, id: @result
    end

    assert_redirected_to results_path
  end
end

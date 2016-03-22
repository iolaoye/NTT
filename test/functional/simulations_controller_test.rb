require 'test_helper'

class SimulationsControllerTest < ActionController::TestCase
  setup do
    @simulation = simulations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:simulations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create simulation" do
    assert_difference('Simulation.count') do
      post :create, simulation: { comments: @simulation.comments, field_id: @simulation.field_id, fields: @simulation.fields, las_simulation: @simulation.las_simulation, layers: @simulation.layers, location: @simulation.location, management: @simulation.management, project: @simulation.project, scenario_id: @simulation.scenario_id, soils: @simulation.soils, subproject_id: @simulation.subproject_id, type_id: @simulation.type_id, weather: @simulation.weather }
    end

    assert_redirected_to simulation_path(assigns(:simulation))
  end

  test "should show simulation" do
    get :show, id: @simulation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @simulation
    assert_response :success
  end

  test "should update simulation" do
    put :update, id: @simulation, simulation: { comments: @simulation.comments, field_id: @simulation.field_id, fields: @simulation.fields, las_simulation: @simulation.las_simulation, layers: @simulation.layers, location: @simulation.location, management: @simulation.management, project: @simulation.project, scenario_id: @simulation.scenario_id, soils: @simulation.soils, subproject_id: @simulation.subproject_id, type_id: @simulation.type_id, weather: @simulation.weather }
    assert_redirected_to simulation_path(assigns(:simulation))
  end

  test "should destroy simulation" do
    assert_difference('Simulation.count', -1) do
      delete :destroy, id: @simulation
    end

    assert_redirected_to simulations_path
  end
end

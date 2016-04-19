require 'test_helper'

class CroppingSystemsControllerTest < ActionController::TestCase
  setup do
    @cropping_system = cropping_systems(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cropping_systems)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cropping_system" do
    assert_difference('CroppingSystem.count') do
      post :create, cropping_system: { crop: @cropping_system.crop, grazing: @cropping_system.grazing, name: @cropping_system.name, state_id: @cropping_system.state_id, status: @cropping_system.status, tillage: @cropping_system.tillage, var12: @cropping_system.var12 }
    end

    assert_redirected_to cropping_system_path(assigns(:cropping_system))
  end

  test "should show cropping_system" do
    get :show, id: @cropping_system
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cropping_system
    assert_response :success
  end

  test "should update cropping_system" do
    put :update, id: @cropping_system, cropping_system: { crop: @cropping_system.crop, grazing: @cropping_system.grazing, name: @cropping_system.name, state_id: @cropping_system.state_id, status: @cropping_system.status, tillage: @cropping_system.tillage, var12: @cropping_system.var12 }
    assert_redirected_to cropping_system_path(assigns(:cropping_system))
  end

  test "should destroy cropping_system" do
    assert_difference('CroppingSystem.count', -1) do
      delete :destroy, id: @cropping_system
    end

    assert_redirected_to cropping_systems_path
  end
end

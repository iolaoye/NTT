require 'test_helper'

class SoilOperationsControllerTest < ActionController::TestCase
  setup do
    @soil_operation = soil_operations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:soil_operations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create soil_operation" do
    assert_difference('SoilOperation.count') do
      post :create, soil_operation: {  }
    end

    assert_redirected_to soil_operation_path(assigns(:soil_operation))
  end

  test "should show soil_operation" do
    get :show, id: @soil_operation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @soil_operation
    assert_response :success
  end

  test "should update soil_operation" do
    put :update, id: @soil_operation, soil_operation: {  }
    assert_redirected_to soil_operation_path(assigns(:soil_operation))
  end

  test "should destroy soil_operation" do
    assert_difference('SoilOperation.count', -1) do
      delete :destroy, id: @soil_operation
    end

    assert_redirected_to soil_operations_path
  end
end

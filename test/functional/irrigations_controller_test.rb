require 'test_helper'

class IrrigationsControllerTest < ActionController::TestCase
  setup do
    @irrigation = irrigations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:irrigations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create irrigation" do
    assert_difference('Irrigation.count') do
      post :create, irrigation: { name: @irrigation.name, status: @irrigation.status }
    end

    assert_redirected_to irrigation_path(assigns(:irrigation))
  end

  test "should show irrigation" do
    get :show, id: @irrigation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @irrigation
    assert_response :success
  end

  test "should update irrigation" do
    put :update, id: @irrigation, irrigation: { name: @irrigation.name, status: @irrigation.status }
    assert_redirected_to irrigation_path(assigns(:irrigation))
  end

  test "should destroy irrigation" do
    assert_difference('Irrigation.count', -1) do
      delete :destroy, id: @irrigation
    end

    assert_redirected_to irrigations_path
  end
end

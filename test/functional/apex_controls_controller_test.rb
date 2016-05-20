require 'test_helper'

class ApexControlsControllerTest < ActionController::TestCase
  setup do
    @apex_control = apex_controls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:apex_controls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create apex_control" do
    assert_difference('ApexControl.count') do
      post :create, apex_control: { control_id: @apex_control.control_id, value: @apex_control.value }
    end

    assert_redirected_to apex_control_path(assigns(:apex_control))
  end

  test "should show apex_control" do
    get :show, id: @apex_control
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @apex_control
    assert_response :success
  end

  test "should update apex_control" do
    put :update, id: @apex_control, apex_control: { control_id: @apex_control.control_id, value: @apex_control.value }
    assert_redirected_to apex_control_path(assigns(:apex_control))
  end

  test "should destroy apex_control" do
    assert_difference('ApexControl.count', -1) do
      delete :destroy, id: @apex_control
    end

    assert_redirected_to apex_controls_path
  end
end

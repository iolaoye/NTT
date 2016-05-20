require 'test_helper'

class ApexParametersControllerTest < ActionController::TestCase
  setup do
    @apex_parameter = apex_parameters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:apex_parameters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create apex_parameter" do
    assert_difference('ApexParameter.count') do
      post :create, apex_parameter: { parameter_id: @apex_parameter.parameter_id, project_id: @apex_parameter.project_id, value: @apex_parameter.value }
    end

    assert_redirected_to apex_parameter_path(assigns(:apex_parameter))
  end

  test "should show apex_parameter" do
    get :show, id: @apex_parameter
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @apex_parameter
    assert_response :success
  end

  test "should update apex_parameter" do
    put :update, id: @apex_parameter, apex_parameter: { parameter_id: @apex_parameter.parameter_id, project_id: @apex_parameter.project_id, value: @apex_parameter.value }
    assert_redirected_to apex_parameter_path(assigns(:apex_parameter))
  end

  test "should destroy apex_parameter" do
    assert_difference('ApexParameter.count', -1) do
      delete :destroy, id: @apex_parameter
    end

    assert_redirected_to apex_parameters_path
  end
end

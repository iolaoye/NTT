require 'test_helper'

class FertilizerTypesControllerTest < ActionController::TestCase
  setup do
    @fertilizer_type = fertilizer_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fertilizer_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fertilizer_type" do
    assert_difference('FertilizerType.count') do
      post :create, fertilizer_type: { name: @fertilizer_type.name, spanish_name: @fertilizer_type.spanish_name }
    end

    assert_redirected_to fertilizer_type_path(assigns(:fertilizer_type))
  end

  test "should show fertilizer_type" do
    get :show, id: @fertilizer_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fertilizer_type
    assert_response :success
  end

  test "should update fertilizer_type" do
    put :update, id: @fertilizer_type, fertilizer_type: { name: @fertilizer_type.name, spanish_name: @fertilizer_type.spanish_name }
    assert_redirected_to fertilizer_type_path(assigns(:fertilizer_type))
  end

  test "should destroy fertilizer_type" do
    assert_difference('FertilizerType.count', -1) do
      delete :destroy, id: @fertilizer_type
    end

    assert_redirected_to fertilizer_types_path
  end
end

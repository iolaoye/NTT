require 'test_helper'

class SoilTestsControllerTest < ActionController::TestCase
  setup do
    @soil_test = soil_tests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:soil_tests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create soil_test" do
    assert_difference('SoilTest.count') do
      post :create, soil_test: { factor1: @soil_test.factor1, factor2: @soil_test.factor2, name: @soil_test.name }
    end

    assert_redirected_to soil_test_path(assigns(:soil_test))
  end

  test "should show soil_test" do
    get :show, id: @soil_test
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @soil_test
    assert_response :success
  end

  test "should update soil_test" do
    patch :update, id: @soil_test, soil_test: { factor1: @soil_test.factor1, factor2: @soil_test.factor2, name: @soil_test.name }
    assert_redirected_to soil_test_path(assigns(:soil_test))
  end

  test "should destroy soil_test" do
    assert_difference('SoilTest.count', -1) do
      delete :destroy, id: @soil_test
    end

    assert_redirected_to soil_tests_path
  end
end

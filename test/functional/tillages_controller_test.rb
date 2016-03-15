require 'test_helper'

class TillagesControllerTest < ActionController::TestCase
  setup do
    @tillage = tillages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tillages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tillage" do
    assert_difference('Tillage.count') do
      post :create, tillage: { abbreviation: @tillage.abbreviation, code: @tillage.code, dndc: @tillage.dndc, eqp: @tillage.eqp, name: @tillage.name, operation: @tillage.operation, spanish_name: @tillage.spanish_name, status: @tillage.status }
    end

    assert_redirected_to tillage_path(assigns(:tillage))
  end

  test "should show tillage" do
    get :show, id: @tillage
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tillage
    assert_response :success
  end

  test "should update tillage" do
    put :update, id: @tillage, tillage: { abbreviation: @tillage.abbreviation, code: @tillage.code, dndc: @tillage.dndc, eqp: @tillage.eqp, name: @tillage.name, operation: @tillage.operation, spanish_name: @tillage.spanish_name, status: @tillage.status }
    assert_redirected_to tillage_path(assigns(:tillage))
  end

  test "should destroy tillage" do
    assert_difference('Tillage.count', -1) do
      delete :destroy, id: @tillage
    end

    assert_redirected_to tillages_path
  end
end

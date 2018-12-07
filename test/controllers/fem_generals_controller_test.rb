require 'test_helper'

class FemGeneralsControllerTest < ActionController::TestCase
  setup do
    @fem_general = fem_generals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fem_generals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fem_general" do
    assert_difference('FemGeneral.count') do
      post :create, fem_general: { name: @fem_general.name, value: @fem_general.value }
    end

    assert_redirected_to fem_general_path(assigns(:fem_general))
  end

  test "should show fem_general" do
    get :show, id: @fem_general
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fem_general
    assert_response :success
  end

  test "should update fem_general" do
    patch :update, id: @fem_general, fem_general: { name: @fem_general.name, value: @fem_general.value }
    assert_redirected_to fem_general_path(assigns(:fem_general))
  end

  test "should destroy fem_general" do
    assert_difference('FemGeneral.count', -1) do
      delete :destroy, id: @fem_general
    end

    assert_redirected_to fem_generals_path
  end
end

require 'test_helper'

class SubareasControllerTest < ActionController::TestCase
  setup do
    @subarea = subareas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subareas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subarea" do
    assert_difference('Subarea.count') do
      post :create, subarea: {  }
    end

    assert_redirected_to subarea_path(assigns(:subarea))
  end

  test "should show subarea" do
    get :show, id: @subarea
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subarea
    assert_response :success
  end

  test "should update subarea" do
    put :update, id: @subarea, subarea: {  }
    assert_redirected_to subarea_path(assigns(:subarea))
  end

  test "should destroy subarea" do
    assert_difference('Subarea.count', -1) do
      delete :destroy, id: @subarea
    end

    assert_redirected_to subareas_path
  end
end

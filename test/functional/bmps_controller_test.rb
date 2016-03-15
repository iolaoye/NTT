require 'test_helper'

class BmpsControllerTest < ActionController::TestCase
  setup do
    @bmp = bmps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bmps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bmp" do
    assert_difference('Bmp.count') do
      post :create, bmp: { scenario_id: @bmp.scenario_id }
    end

    assert_redirected_to bmp_path(assigns(:bmp))
  end

  test "should show bmp" do
    get :show, id: @bmp
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bmp
    assert_response :success
  end

  test "should update bmp" do
    put :update, id: @bmp, bmp: { scenario_id: @bmp.scenario_id }
    assert_redirected_to bmp_path(assigns(:bmp))
  end

  test "should destroy bmp" do
    assert_difference('Bmp.count', -1) do
      delete :destroy, id: @bmp
    end

    assert_redirected_to bmps_path
  end
end

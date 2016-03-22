require 'test_helper'

class FertilizersControllerTest < ActionController::TestCase
  setup do
    @fertilizer = fertilizers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fertilizers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fertilizer" do
    assert_difference('Fertilizer.count') do
      post :create, fertilizer: { abbreviation: @fertilizer.abbreviation, activity_id: @fertilizer.activity_id, code: @fertilizer.code, dndc: @fertilizer.dndc, name: @fertilizer.name, operation: @fertilizer.operation, spinsh_name: @fertilizer.spinsh_name, status: @fertilizer.status }
    end

    assert_redirected_to fertilizer_path(assigns(:fertilizer))
  end

  test "should show fertilizer" do
    get :show, id: @fertilizer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fertilizer
    assert_response :success
  end

  test "should update fertilizer" do
    put :update, id: @fertilizer, fertilizer: { abbreviation: @fertilizer.abbreviation, activity_id: @fertilizer.activity_id, code: @fertilizer.code, dndc: @fertilizer.dndc, name: @fertilizer.name, operation: @fertilizer.operation, spinsh_name: @fertilizer.spinsh_name, status: @fertilizer.status }
    assert_redirected_to fertilizer_path(assigns(:fertilizer))
  end

  test "should destroy fertilizer" do
    assert_difference('Fertilizer.count', -1) do
      delete :destroy, id: @fertilizer
    end

    assert_redirected_to fertilizers_path
  end
end

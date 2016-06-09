require 'test_helper'

class WatershedsControllerTest < ActionController::TestCase
  setup do
    @watershed = watersheds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:watersheds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create watershed" do
    assert_difference('Watershed.count') do
      post :create, watershed: { field_id: @watershed.field_id, name: @watershed.name, scenario_id: @watershed.scenario_id }
    end

    assert_redirected_to watershed_path(assigns(:watershed))
  end

  test "should show watershed" do
    get :show, id: @watershed
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @watershed
    assert_response :success
  end

  test "should update watershed" do
    put :update, id: @watershed, watershed: { field_id: @watershed.field_id, name: @watershed.name, scenario_id: @watershed.scenario_id }
    assert_redirected_to watershed_path(assigns(:watershed))
  end

  test "should destroy watershed" do
    assert_difference('Watershed.count', -1) do
      delete :destroy, id: @watershed
    end

    assert_redirected_to watersheds_path
  end
end

require 'test_helper'

class FemFacilitiesControllerTest < ActionController::TestCase
  setup do
    @fem_facility = fem_facilities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fem_facilities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fem_facility" do
    assert_difference('FemFacility.count') do
      post :create, fem_facility: {  }
    end

    assert_redirected_to fem_facility_path(assigns(:fem_facility))
  end

  test "should show fem_facility" do
    get :show, id: @fem_facility
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fem_facility
    assert_response :success
  end

  test "should update fem_facility" do
    patch :update, id: @fem_facility, fem_facility: {  }
    assert_redirected_to fem_facility_path(assigns(:fem_facility))
  end

  test "should destroy fem_facility" do
    assert_difference('FemFacility.count', -1) do
      delete :destroy, id: @fem_facility
    end

    assert_redirected_to fem_facilities_path
  end
end

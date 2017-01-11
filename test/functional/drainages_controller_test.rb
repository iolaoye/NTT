require 'test_helper'

class DrainagesControllerTest < ActionController::TestCase
  setup do
    @drainage = drainages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:drainages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create drainage" do
    assert_difference('Drainage.count') do
      post :create, drainage: { id: @drainage.id, name: @drainage.name, wtbl: @drainage.wtbl, wtmn: @drainage.wtmn, wtmx: @drainage.wtmx, zqt: @drainage.zqt, ztk: @drainage.ztk }
    end

    assert_redirected_to drainage_path(assigns(:drainage))
  end

  test "should show drainage" do
    get :show, id: @drainage
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @drainage
    assert_response :success
  end

  test "should update drainage" do
    put :update, id: @drainage, drainage: { id: @drainage.id, name: @drainage.name, wtbl: @drainage.wtbl, wtmn: @drainage.wtmn, wtmx: @drainage.wtmx, zqt: @drainage.zqt, ztk: @drainage.ztk }
    assert_redirected_to drainage_path(assigns(:drainage))
  end

  test "should destroy drainage" do
    assert_difference('Drainage.count', -1) do
      delete :destroy, id: @drainage
    end

    assert_redirected_to drainages_path
  end
end

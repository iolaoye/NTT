require 'test_helper'

class BmpsublistsControllerTest < ActionController::TestCase
  setup do
    @bmpsublist = bmpsublists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bmpsublists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bmpsublist" do
    assert_difference('Bmpsublist.count') do
      post :create, bmpsublist: { name: @bmpsublist.name, status: @bmpsublist.status }
    end

    assert_redirected_to bmpsublist_path(assigns(:bmpsublist))
  end

  test "should show bmpsublist" do
    get :show, id: @bmpsublist
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bmpsublist
    assert_response :success
  end

  test "should update bmpsublist" do
    put :update, id: @bmpsublist, bmpsublist: { name: @bmpsublist.name, status: @bmpsublist.status }
    assert_redirected_to bmpsublist_path(assigns(:bmpsublist))
  end

  test "should destroy bmpsublist" do
    assert_difference('Bmpsublist.count', -1) do
      delete :destroy, id: @bmpsublist
    end

    assert_redirected_to bmpsublists_path
  end
end

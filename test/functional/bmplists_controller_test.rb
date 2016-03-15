require 'test_helper'

class BmplistsControllerTest < ActionController::TestCase
  setup do
    @bmplist = bmplists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bmplists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bmplist" do
    assert_difference('Bmplist.count') do
      post :create, bmplist: { name: @bmplist.name }
    end

    assert_redirected_to bmplist_path(assigns(:bmplist))
  end

  test "should show bmplist" do
    get :show, id: @bmplist
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bmplist
    assert_response :success
  end

  test "should update bmplist" do
    put :update, id: @bmplist, bmplist: { name: @bmplist.name }
    assert_redirected_to bmplist_path(assigns(:bmplist))
  end

  test "should destroy bmplist" do
    assert_difference('Bmplist.count', -1) do
      delete :destroy, id: @bmplist
    end

    assert_redirected_to bmplists_path
  end
end

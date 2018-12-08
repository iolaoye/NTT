require 'test_helper'

class FemFeedsControllerTest < ActionController::TestCase
  setup do
    @fem_feed = fem_feeds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fem_feeds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fem_feed" do
    assert_difference('FemFeed.count') do
      post :create, fem_feed: { concentrate: @fem_feed.concentrate, forage: @fem_feed.forage, grain: @fem_feed.grain, hay: @fem_feed.hay, name: @fem_feed.name, pasture: @fem_feed.pasture, purchase_price: @fem_feed.purchase_price, selling_price: @fem_feed.selling_price, silage: @fem_feed.silage, supplement: @fem_feed.supplement }
    end

    assert_redirected_to fem_feed_path(assigns(:fem_feed))
  end

  test "should show fem_feed" do
    get :show, id: @fem_feed
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fem_feed
    assert_response :success
  end

  test "should update fem_feed" do
    patch :update, id: @fem_feed, fem_feed: { concentrate: @fem_feed.concentrate, forage: @fem_feed.forage, grain: @fem_feed.grain, hay: @fem_feed.hay, name: @fem_feed.name, pasture: @fem_feed.pasture, purchase_price: @fem_feed.purchase_price, selling_price: @fem_feed.selling_price, silage: @fem_feed.silage, supplement: @fem_feed.supplement }
    assert_redirected_to fem_feed_path(assigns(:fem_feed))
  end

  test "should destroy fem_feed" do
    assert_difference('FemFeed.count', -1) do
      delete :destroy, id: @fem_feed
    end

    assert_redirected_to fem_feeds_path
  end
end

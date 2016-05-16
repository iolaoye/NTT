require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  setup do
    @site = sites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site" do
    assert_difference('Site.count') do
      post :create, site: { apm: @site.apm, co2x: @site.co2x, cqnx: @site.cqnx, elev: @site.elev, fir0: @site.fir0, rfnx: @site.rfnx, unr: @site.unr, upr: @site.upr, xlog: @site.xlog, ylat: @site.ylat }
    end

    assert_redirected_to site_path(assigns(:site))
  end

  test "should show site" do
    get :show, id: @site
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @site
    assert_response :success
  end

  test "should update site" do
    put :update, id: @site, site: { apm: @site.apm, co2x: @site.co2x, cqnx: @site.cqnx, elev: @site.elev, fir0: @site.fir0, rfnx: @site.rfnx, unr: @site.unr, upr: @site.upr, xlog: @site.xlog, ylat: @site.ylat }
    assert_redirected_to site_path(assigns(:site))
  end

  test "should destroy site" do
    assert_difference('Site.count', -1) do
      delete :destroy, id: @site
    end

    assert_redirected_to sites_path
  end
end

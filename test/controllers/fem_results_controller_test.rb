require 'test_helper'

class FemResultsControllerTest < ActionController::TestCase
  setup do
    @fem_result = fem_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fem_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fem_result" do
    assert_difference('FemResult.count') do
      post :create, fem_result: { net_cash_flow: @fem_result.net_cash_flow, net_return: @fem_result.net_return, total_cost: @fem_result.total_cost, total_revenue: @fem_result.total_revenue }
    end

    assert_redirected_to fem_result_path(assigns(:fem_result))
  end

  test "should show fem_result" do
    get :show, id: @fem_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fem_result
    assert_response :success
  end

  test "should update fem_result" do
    patch :update, id: @fem_result, fem_result: { net_cash_flow: @fem_result.net_cash_flow, net_return: @fem_result.net_return, total_cost: @fem_result.total_cost, total_revenue: @fem_result.total_revenue }
    assert_redirected_to fem_result_path(assigns(:fem_result))
  end

  test "should destroy fem_result" do
    assert_difference('FemResult.count', -1) do
      delete :destroy, id: @fem_result
    end

    assert_redirected_to fem_results_path
  end
end

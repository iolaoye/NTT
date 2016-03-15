require 'test_helper'

class OperationsControllerTest < ActionController::TestCase
  setup do
    @operation = operations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:operations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create operation" do
    assert_difference('Operation.count') do
      post :create, operation: { amount: @operation.amount, crop_id: @operation.crop_id, day: @operation.day, depth: @operation.depth, month_id: @operation.month_id, nh3: @operation.nh3, no3_n: @operation.no3_n, operation_id: @operation.operation_id, org_n: @operation.org_n, org_p: @operation.org_p, po4_p: @operation.po4_p, type_id: @operation.type_id, year: @operation.year }
    end

    assert_redirected_to operation_path(assigns(:operation))
  end

  test "should show operation" do
    get :show, id: @operation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @operation
    assert_response :success
  end

  test "should update operation" do
    put :update, id: @operation, operation: { amount: @operation.amount, crop_id: @operation.crop_id, day: @operation.day, depth: @operation.depth, month_id: @operation.month_id, nh3: @operation.nh3, no3_n: @operation.no3_n, operation_id: @operation.operation_id, org_n: @operation.org_n, org_p: @operation.org_p, po4_p: @operation.po4_p, type_id: @operation.type_id, year: @operation.year }
    assert_redirected_to operation_path(assigns(:operation))
  end

  test "should destroy operation" do
    assert_difference('Operation.count', -1) do
      delete :destroy, id: @operation
    end

    assert_redirected_to operations_path
  end
end

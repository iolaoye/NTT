require 'test_helper'

class FemMachinesControllerTest < ActionController::TestCase
  setup do
    @fem_machine = fem_machines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fem_machines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fem_machine" do
    assert_difference('FemMachine.count') do
      post :create, fem_machine: {  }
    end

    assert_redirected_to fem_machine_path(assigns(:fem_machine))
  end

  test "should show fem_machine" do
    get :show, id: @fem_machine
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fem_machine
    assert_response :success
  end

  test "should update fem_machine" do
    patch :update, id: @fem_machine, fem_machine: {  }
    assert_redirected_to fem_machine_path(assigns(:fem_machine))
  end

  test "should destroy fem_machine" do
    assert_difference('FemMachine.count', -1) do
      delete :destroy, id: @fem_machine
    end

    assert_redirected_to fem_machines_path
  end
end

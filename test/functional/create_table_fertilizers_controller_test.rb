require 'test_helper'

class CreateTableFertilizersControllerTest < ActionController::TestCase
  setup do
    @create_table_fertilizer = create_table_fertilizers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:create_table_fertilizers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create create_table_fertilizer" do
    assert_difference('CreateTableFertilizer.count') do
      post :create, create_table_fertilizer: { code: @create_table_fertilizer.code, lbs: @create_table_fertilizer.lbs, name: @create_table_fertilizer.name, nh3: @create_table_fertilizer.nh3, qn: @create_table_fertilizer.qn, qp: @create_table_fertilizer.qp, spanish_name: @create_table_fertilizer.spanish_name, status=boolean: @create_table_fertilizer.status=boolean, type: @create_table_fertilizer.type, yn: @create_table_fertilizer.yn, yp: @create_table_fertilizer.yp }
    end

    assert_redirected_to create_table_fertilizer_path(assigns(:create_table_fertilizer))
  end

  test "should show create_table_fertilizer" do
    get :show, id: @create_table_fertilizer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @create_table_fertilizer
    assert_response :success
  end

  test "should update create_table_fertilizer" do
    put :update, id: @create_table_fertilizer, create_table_fertilizer: { code: @create_table_fertilizer.code, lbs: @create_table_fertilizer.lbs, name: @create_table_fertilizer.name, nh3: @create_table_fertilizer.nh3, qn: @create_table_fertilizer.qn, qp: @create_table_fertilizer.qp, spanish_name: @create_table_fertilizer.spanish_name, status=boolean: @create_table_fertilizer.status=boolean, type: @create_table_fertilizer.type, yn: @create_table_fertilizer.yn, yp: @create_table_fertilizer.yp }
    assert_redirected_to create_table_fertilizer_path(assigns(:create_table_fertilizer))
  end

  test "should destroy create_table_fertilizer" do
    assert_difference('CreateTableFertilizer.count', -1) do
      delete :destroy, id: @create_table_fertilizer
    end

    assert_redirected_to create_table_fertilizers_path
  end
end

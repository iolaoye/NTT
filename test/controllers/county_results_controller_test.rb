require 'test_helper'

class CountyResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @county_result = county_results(:one)
  end

  test "should get index" do
    get county_results_url
    assert_response :success
  end

  test "should get new" do
    get new_county_result_url
    assert_response :success
  end

  test "should create county_result" do
    assert_difference('CountyResult.count') do
      post county_results_url, params: { county_result: {  } }
    end

    assert_redirected_to county_result_url(CountyResult.last)
  end

  test "should show county_result" do
    get county_result_url(@county_result)
    assert_response :success
  end

  test "should get edit" do
    get edit_county_result_url(@county_result)
    assert_response :success
  end

  test "should update county_result" do
    patch county_result_url(@county_result), params: { county_result: {  } }
    assert_redirected_to county_result_url(@county_result)
  end

  test "should destroy county_result" do
    assert_difference('CountyResult.count', -1) do
      delete county_result_url(@county_result)
    end

    assert_redirected_to county_results_url
  end
end

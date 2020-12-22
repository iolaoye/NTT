require 'test_helper'

class CountyCropResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @county_crop_result = county_crop_results(:one)
  end

  test "should get index" do
    get county_crop_results_url
    assert_response :success
  end

  test "should get new" do
    get new_county_crop_result_url
    assert_response :success
  end

  test "should create county_crop_result" do
    assert_difference('CountyCropResult.count') do
      post county_crop_results_url, params: { county_crop_result: { county_id: @county_crop_result.county_id, name: @county_crop_result.name, ns: @county_crop_result.ns, ps: @county_crop_result.ps, scenario_id: @county_crop_result.scenario_id, state_id: @county_crop_result.state_id, ts: @county_crop_result.ts, ws: @county_crop_result.ws, yield: @county_crop_result.yield, yield_ci: @county_crop_result.yield_ci } }
    end

    assert_redirected_to county_crop_result_url(CountyCropResult.last)
  end

  test "should show county_crop_result" do
    get county_crop_result_url(@county_crop_result)
    assert_response :success
  end

  test "should get edit" do
    get edit_county_crop_result_url(@county_crop_result)
    assert_response :success
  end

  test "should update county_crop_result" do
    patch county_crop_result_url(@county_crop_result), params: { county_crop_result: { county_id: @county_crop_result.county_id, name: @county_crop_result.name, ns: @county_crop_result.ns, ps: @county_crop_result.ps, scenario_id: @county_crop_result.scenario_id, state_id: @county_crop_result.state_id, ts: @county_crop_result.ts, ws: @county_crop_result.ws, yield: @county_crop_result.yield, yield_ci: @county_crop_result.yield_ci } }
    assert_redirected_to county_crop_result_url(@county_crop_result)
  end

  test "should destroy county_crop_result" do
    assert_difference('CountyCropResult.count', -1) do
      delete county_crop_result_url(@county_crop_result)
    end

    assert_redirected_to county_crop_results_url
  end
end

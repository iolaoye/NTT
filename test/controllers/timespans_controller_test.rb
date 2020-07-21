require 'test_helper'

class TimespansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @timespan = timespans(:one)
  end

  test "should get index" do
    get timespans_url
    assert_response :success
  end

  test "should get new" do
    get new_timespan_url
    assert_response :success
  end

  test "should create timespan" do
    assert_difference('Timespan.count') do
      post timespans_url, params: { timespan: { bmp_id: @timespan.bmp_id, crop_id: @timespan.crop_id, end_day: @timespan.end_day, end_month: @timespan.end_month, start_day: @timespan.start_day, start_month: @timespan.start_month } }
    end

    assert_redirected_to timespan_url(Timespan.last)
  end

  test "should show timespan" do
    get timespan_url(@timespan)
    assert_response :success
  end

  test "should get edit" do
    get edit_timespan_url(@timespan)
    assert_response :success
  end

  test "should update timespan" do
    patch timespan_url(@timespan), params: { timespan: { bmp_id: @timespan.bmp_id, crop_id: @timespan.crop_id, end_day: @timespan.end_day, end_month: @timespan.end_month, start_day: @timespan.start_day, start_month: @timespan.start_month } }
    assert_redirected_to timespan_url(@timespan)
  end

  test "should destroy timespan" do
    assert_difference('Timespan.count', -1) do
      delete timespan_url(@timespan)
    end

    assert_redirected_to timespans_url
  end
end

require "application_system_test_case"

class TimespansTest < ApplicationSystemTestCase
  setup do
    @timespan = timespans(:one)
  end

  test "visiting the index" do
    visit timespans_url
    assert_selector "h1", text: "Timespans"
  end

  test "creating a Timespan" do
    visit timespans_url
    click_on "New Timespan"

    fill_in "Bmp", with: @timespan.bmp_id
    fill_in "Crop", with: @timespan.crop_id
    fill_in "End day", with: @timespan.end_day
    fill_in "End month", with: @timespan.end_month
    fill_in "Start day", with: @timespan.start_day
    fill_in "Start month", with: @timespan.start_month
    click_on "Create Timespan"

    assert_text "Timespan was successfully created"
    click_on "Back"
  end

  test "updating a Timespan" do
    visit timespans_url
    click_on "Edit", match: :first

    fill_in "Bmp", with: @timespan.bmp_id
    fill_in "Crop", with: @timespan.crop_id
    fill_in "End day", with: @timespan.end_day
    fill_in "End month", with: @timespan.end_month
    fill_in "Start day", with: @timespan.start_day
    fill_in "Start month", with: @timespan.start_month
    click_on "Update Timespan"

    assert_text "Timespan was successfully updated"
    click_on "Back"
  end

  test "destroying a Timespan" do
    visit timespans_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Timespan was successfully destroyed"
  end
end

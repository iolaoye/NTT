require "application_system_test_case"

class ClimesTest < ApplicationSystemTestCase
  setup do
    @clime = climes(:one)
  end

  test "visiting the index" do
    visit climes_url
    assert_selector "h1", text: "Climes"
  end

  test "creating a Clime" do
    visit climes_url
    click_on "New Clime"

    fill_in "Daily weather", with: @clime.daily_weather
    fill_in "Field", with: @clime.field_id
    click_on "Create Clime"

    assert_text "Clime was successfully created"
    click_on "Back"
  end

  test "updating a Clime" do
    visit climes_url
    click_on "Edit", match: :first

    fill_in "Daily weather", with: @clime.daily_weather
    fill_in "Field", with: @clime.field_id
    click_on "Update Clime"

    assert_text "Clime was successfully updated"
    click_on "Back"
  end

  test "destroying a Clime" do
    visit climes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Clime was successfully destroyed"
  end
end

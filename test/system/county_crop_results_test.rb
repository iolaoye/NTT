require "application_system_test_case"

class CountyCropResultsTest < ApplicationSystemTestCase
  setup do
    @county_crop_result = county_crop_results(:one)
  end

  test "visiting the index" do
    visit county_crop_results_url
    assert_selector "h1", text: "County Crop Results"
  end

  test "creating a County crop result" do
    visit county_crop_results_url
    click_on "New County Crop Result"

    fill_in "County", with: @county_crop_result.county_id
    fill_in "Name", with: @county_crop_result.name
    fill_in "Ns", with: @county_crop_result.ns
    fill_in "Ps", with: @county_crop_result.ps
    fill_in "Scenario", with: @county_crop_result.scenario_id
    fill_in "State", with: @county_crop_result.state_id
    fill_in "Ts", with: @county_crop_result.ts
    fill_in "Ws", with: @county_crop_result.ws
    fill_in "Yield", with: @county_crop_result.yield
    fill_in "Yield ci", with: @county_crop_result.yield_ci
    click_on "Create County crop result"

    assert_text "County crop result was successfully created"
    click_on "Back"
  end

  test "updating a County crop result" do
    visit county_crop_results_url
    click_on "Edit", match: :first

    fill_in "County", with: @county_crop_result.county_id
    fill_in "Name", with: @county_crop_result.name
    fill_in "Ns", with: @county_crop_result.ns
    fill_in "Ps", with: @county_crop_result.ps
    fill_in "Scenario", with: @county_crop_result.scenario_id
    fill_in "State", with: @county_crop_result.state_id
    fill_in "Ts", with: @county_crop_result.ts
    fill_in "Ws", with: @county_crop_result.ws
    fill_in "Yield", with: @county_crop_result.yield
    fill_in "Yield ci", with: @county_crop_result.yield_ci
    click_on "Update County crop result"

    assert_text "County crop result was successfully updated"
    click_on "Back"
  end

  test "destroying a County crop result" do
    visit county_crop_results_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "County crop result was successfully destroyed"
  end
end

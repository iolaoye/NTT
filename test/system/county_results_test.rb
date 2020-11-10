require "application_system_test_case"

class CountyResultsTest < ApplicationSystemTestCase
  setup do
    @county_result = county_results(:one)
  end

  test "visiting the index" do
    visit county_results_url
    assert_selector "h1", text: "County Results"
  end

  test "creating a County result" do
    visit county_results_url
    click_on "New County Result"

    click_on "Create County result"

    assert_text "County result was successfully created"
    click_on "Back"
  end

  test "updating a County result" do
    visit county_results_url
    click_on "Edit", match: :first

    click_on "Update County result"

    assert_text "County result was successfully updated"
    click_on "Back"
  end

  test "destroying a County result" do
    visit county_results_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "County result was successfully destroyed"
  end
end

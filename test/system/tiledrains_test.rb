require "application_system_test_case"

class TiledrainsTest < ApplicationSystemTestCase
  setup do
    @tiledrain = tiledrains(:one)
  end

  test "visiting the index" do
    visit tiledrains_url
    assert_selector "h1", text: "Tiledrains"
  end

  test "creating a Tiledrain" do
    visit tiledrains_url
    click_on "New Tiledrain"

    click_on "Create Tiledrain"

    assert_text "Tiledrain was successfully created"
    click_on "Back"
  end

  test "updating a Tiledrain" do
    visit tiledrains_url
    click_on "Edit", match: :first

    click_on "Update Tiledrain"

    assert_text "Tiledrain was successfully updated"
    click_on "Back"
  end

  test "destroying a Tiledrain" do
    visit tiledrains_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tiledrain was successfully destroyed"
  end
end

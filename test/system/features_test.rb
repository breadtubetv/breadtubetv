require "application_system_test_case"

class FeaturesTest < ApplicationSystemTestCase
  setup do
    @feature = features(:one)
  end

  test "visiting the index" do
    visit features_url
    assert_selector "h1", text: "Features"
  end

  test "creating a Feature" do
    visit features_url
    click_on "New Feature"

    fill_in "Channel", with: @feature.channel_id
    fill_in "Expired at", with: @feature.expired_at
    click_on "Create Feature"

    assert_text "Feature was successfully created"
    click_on "Back"
  end

  test "updating a Feature" do
    visit features_url
    click_on "Edit", match: :first

    fill_in "Channel", with: @feature.channel_id
    fill_in "Expired at", with: @feature.expired_at
    click_on "Update Feature"

    assert_text "Feature was successfully updated"
    click_on "Back"
  end

  test "destroying a Feature" do
    visit features_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Feature was successfully destroyed"
  end
end

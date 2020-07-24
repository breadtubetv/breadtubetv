require "application_system_test_case"

class ChannelSupportsTest < ApplicationSystemTestCase
  setup do
    @channel_support = channel_supports(:one)
  end

  test "visiting the index" do
    visit channel_supports_url
    assert_selector "h1", text: "Channel Supports"
  end

  test "creating a Channel support" do
    visit channel_supports_url
    click_on "New Channel Support"

    fill_in "Channel", with: @channel_support.channel
    fill_in "Ident", with: @channel_support.ident
    fill_in "Url", with: @channel_support.url
    click_on "Create Channel support"

    assert_text "Channel support was successfully created"
    click_on "Back"
  end

  test "updating a Channel support" do
    visit channel_supports_url
    click_on "Edit", match: :first

    fill_in "Channel", with: @channel_support.channel
    fill_in "Ident", with: @channel_support.ident
    fill_in "Url", with: @channel_support.url
    click_on "Update Channel support"

    assert_text "Channel support was successfully updated"
    click_on "Back"
  end

  test "destroying a Channel support" do
    visit channel_supports_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Channel support was successfully destroyed"
  end
end

require "application_system_test_case"

class ChannelSocialsTest < ApplicationSystemTestCase
  setup do
    @channel_social = channel_socials(:one)
  end

  test "visiting the index" do
    visit channel_socials_url
    assert_selector "h1", text: "Channel Socials"
  end

  test "creating a Channel social" do
    visit channel_socials_url
    click_on "New Channel Social"

    fill_in "Channel", with: @channel_social.channel
    fill_in "Ident", with: @channel_social.ident
    fill_in "Url", with: @channel_social.url
    click_on "Create Channel social"

    assert_text "Channel social was successfully created"
    click_on "Back"
  end

  test "updating a Channel social" do
    visit channel_socials_url
    click_on "Edit", match: :first

    fill_in "Channel", with: @channel_social.channel
    fill_in "Ident", with: @channel_social.ident
    fill_in "Url", with: @channel_social.url
    click_on "Update Channel social"

    assert_text "Channel social was successfully updated"
    click_on "Back"
  end

  test "destroying a Channel social" do
    visit channel_socials_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Channel social was successfully destroyed"
  end
end

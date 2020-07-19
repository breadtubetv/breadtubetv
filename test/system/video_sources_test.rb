require "application_system_test_case"

class VideoSourcesTest < ApplicationSystemTestCase
  setup do
    @video_source = video_sources(:one)
  end

  test "visiting the index" do
    visit video_sources_url
    assert_selector "h1", text: "Video Sources"
  end

  test "creating a Video source" do
    visit video_sources_url
    click_on "New Video Source"

    fill_in "Kind", with: @video_source.kind
    fill_in "Url", with: @video_source.url
    fill_in "Video", with: @video_source.video
    click_on "Create Video source"

    assert_text "Video source was successfully created"
    click_on "Back"
  end

  test "updating a Video source" do
    visit video_sources_url
    click_on "Edit", match: :first

    fill_in "Kind", with: @video_source.kind
    fill_in "Url", with: @video_source.url
    fill_in "Video", with: @video_source.video
    click_on "Update Video source"

    assert_text "Video source was successfully updated"
    click_on "Back"
  end

  test "destroying a Video source" do
    visit video_sources_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Video source was successfully destroyed"
  end
end

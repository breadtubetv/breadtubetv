require 'test_helper'

class VideoSourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @video_source = video_sources(:one)
  end

  test "should get index" do
    get video_sources_url
    assert_response :success
  end

  test "should get new" do
    get new_video_source_url
    assert_response :success
  end

  test "should create video_source" do
    assert_difference('VideoSource.count') do
      post video_sources_url, params: { video_source: { kind: @video_source.kind, url: @video_source.url, video: @video_source.video } }
    end

    assert_redirected_to video_source_url(VideoSource.last)
  end

  test "should show video_source" do
    get video_source_url(@video_source)
    assert_response :success
  end

  test "should get edit" do
    get edit_video_source_url(@video_source)
    assert_response :success
  end

  test "should update video_source" do
    patch video_source_url(@video_source), params: { video_source: { kind: @video_source.kind, url: @video_source.url, video: @video_source.video } }
    assert_redirected_to video_source_url(@video_source)
  end

  test "should destroy video_source" do
    assert_difference('VideoSource.count', -1) do
      delete video_source_url(@video_source)
    end

    assert_redirected_to video_sources_url
  end
end

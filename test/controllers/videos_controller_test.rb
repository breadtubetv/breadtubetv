require 'test_helper'

class VideosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @channel = channels(:one)
    @video = videos(:one)
  end

  test "should get index" do
    get videos_url
    assert_response :success
  end

  test "should get new" do
    get new_video_url
    assert_response :success
  end

  test "should create video" do
    assert_difference('Video.count') do
      post videos_url, params: { video: { channel_id: @channel.id, description: @video.description, name: "#{@video.name} Again", published_at: @video.published_at } }
    end

    assert_redirected_to channel_video_url(Video.last.channel, Video.last)
  end

  test "should show video" do
    get channel_video_url(@video.channel, @video)
    assert_response :success
  end

  test "should get edit" do
    get edit_channel_video_url(@video.channel, @video)
    assert_response :success
  end

  test "should update video" do
    patch channel_video_url(@video.channel, @video), params: { video: { channel_id: @video.channel_id, description: @video.description, name: @video.name, published_at: @video.published_at, slug: @video.slug } }
    assert_redirected_to channel_video_url(@video.channel, @video)
  end

  test "should destroy video" do
    assert_difference('Video.count', -1) do
      delete channel_video_url(@video.channel, @video)
    end

    assert_redirected_to videos_url
  end
end

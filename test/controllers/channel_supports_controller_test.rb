require 'test_helper'

class ChannelSupportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @channel_support = channel_supports(:one)
  end

  test "should get index" do
    get channel_supports_url
    assert_response :success
  end

  test "should get new" do
    get new_channel_support_url
    assert_response :success
  end

  test "should create channel_support" do
    assert_difference('ChannelSupport.count') do
      post channel_supports_url, params: { channel_support: { channel: @channel_support.channel, ident: @channel_support.ident, url: @channel_support.url } }
    end

    assert_redirected_to channel_support_url(ChannelSupport.last)
  end

  test "should show channel_support" do
    get channel_support_url(@channel_support)
    assert_response :success
  end

  test "should get edit" do
    get edit_channel_support_url(@channel_support)
    assert_response :success
  end

  test "should update channel_support" do
    patch channel_support_url(@channel_support), params: { channel_support: { channel: @channel_support.channel, ident: @channel_support.ident, url: @channel_support.url } }
    assert_redirected_to channel_support_url(@channel_support)
  end

  test "should destroy channel_support" do
    assert_difference('ChannelSupport.count', -1) do
      delete channel_support_url(@channel_support)
    end

    assert_redirected_to channel_supports_url
  end
end

require 'test_helper'

class ChannelSocialsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @channel_social = channel_socials(:one)
  end

  test "should get index" do
    get channel_socials_url
    assert_response :success
  end

  test "should get new" do
    get new_channel_social_url
    assert_response :success
  end

  test "should create channel_social" do
    assert_difference('ChannelSocial.count') do
      post channel_socials_url, params: { channel_social: { channel: @channel_social.channel, ident: @channel_social.ident, url: @channel_social.url } }
    end

    assert_redirected_to channel_social_url(ChannelSocial.last)
  end

  test "should show channel_social" do
    get channel_social_url(@channel_social)
    assert_response :success
  end

  test "should get edit" do
    get edit_channel_social_url(@channel_social)
    assert_response :success
  end

  test "should update channel_social" do
    patch channel_social_url(@channel_social), params: { channel_social: { channel: @channel_social.channel, ident: @channel_social.ident, url: @channel_social.url } }
    assert_redirected_to channel_social_url(@channel_social)
  end

  test "should destroy channel_social" do
    assert_difference('ChannelSocial.count', -1) do
      delete channel_social_url(@channel_social)
    end

    assert_redirected_to channel_socials_url
  end
end

Given("12 Videos Exist") do
  FactoryBot.create_list(:video, 12)
end

Given('The {string} {string} Video Exists') do |channel_name, video_name|
  @channel = FactoryBot.create(:channel, name: channel_name)
  @video = FactoryBot.create(:video, channel: @channel, name: video_name)
end

When("I go to the Videos Index") do
  visit videos_path
end

When("I go to the {string} Video Page") do |video|
  video = Video.find_by(name: video)
  visit channel_video_path(video.channel.slug, video.slug)
end

Then("I should see 12 Latest Videos") do
  within "#latest-videos" do
    expect(find('.card-row')).to have_selector('.card', count: 12)
  end
end

Then("I should see 12 Random Videos") do
  within "#random-videos" do
    expect(find('.card-row')).to have_selector('.card', count: 12)
  end
end
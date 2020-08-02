Given('The {string} Channel Exists') do |channel_name|
  FactoryBot.create(:channel, name: channel_name)
end

When("I go to the Channels Index") do
  visit channels_path
end

When("I go to the {string} Channel Page") do |channel|
  channel = Channel.find_by(name: channel)
  visit channel_path(channel.slug)
end

Then("I should see 12 Random Channels") do
  within "#random-channels" do
    expect(find('.card-row')).to have_selector('.card', count: 12)
  end
end
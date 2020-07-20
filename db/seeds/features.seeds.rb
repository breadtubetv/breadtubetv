after :channels, :videos do
  [:literallygarbage, :noncompete, :prolekult, :themajorityreport, :philosophytube, :thoughtslime, :contrapoints, :angiespeaks, :petercoffin,].each do |channel_slug|
    channel = Channel.find_by(slug: channel_slug)
    Feature.create!(channel: channel, expired_at: Time.now + (rand(10) + 1).days)

    puts "Featured: #{ channel.name } Channel"
  end
end
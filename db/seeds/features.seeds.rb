after :channels, :videos do
  [:noncompete, :somemorenews, :prolekult, :themajorityreport, :philosophytube, :thoughtslime, :contrapoints, :angiespeaks, :petercoffin, :unicornriot, :therationalnational, :thejuicemedia].each do |channel_slug|
    channel = Channel.find_by(slug: channel_slug)
    Feature.create!(channel: channel, expire_at: Time.now + (rand(10) + 1).days)

    puts "Featured: #{ channel.name } Channel"
  end
end
after :channels, :videos do
  [
    :radshiba, :indefenseoftoucans, :themichaelbrooksshow,
    :thejuicemedia, :noncompete, :somemorenews,
    :prolekult, :angiespeaks, :themajorityreport,
    :philosophytube, :thoughtslime, :contrapoints
  ].each do |channel_slug|
    channel = Channel.find_by(slug: channel_slug)
    Feature.create!(channel: channel, expire_at: Time.now + (rand(10) + 1).days)

    puts "Featured: #{ channel.name } Channel"
  end
end
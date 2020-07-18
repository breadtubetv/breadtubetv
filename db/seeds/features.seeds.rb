after :channels do
  Channel.order("RANDOM()").limit(10).each do |channel|
    Feature.create!(channel: channel, expired_at: Time.now + (rand(10) + 1).days)

    puts "Featured: #{ channel.name } Channel"
  end
end
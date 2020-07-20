file = File.read("./data/channels.json")
channels = JSON.parse(file)

channels.each do |channel_data|
  channel = Channel.create!(
    name: channel_data["name"],
    description: channel_data["description"],
    slug: channel_data["slug"],
    image: channel_data["image"]
  )

  puts "Created: #{ channel.name } Channel"
  
  (channel_data["sources"] + channel_data["socials"]).each do |source|
    type = source["type"].capitalize

    channel.sources.create!(url: source["url"], type: "ChannelSource::#{ type }")
    
    puts "Created: #{ channel.name } #{ type } Source"
  end
end
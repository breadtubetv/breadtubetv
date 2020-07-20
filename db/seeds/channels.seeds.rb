file = File.read("./data/channels.json")
channels = JSON.parse(file)

channels.each do |channel_data|
  channel = Channel.create!(
    name: channel_data["name"],
    description: channel_data["description"],
    slug: channel_data["slug"],
    image: channel_data["image"],
    tags: channel_data["tags"]
  )

  puts "Created: #{ channel.name } Channel"
  
  channel_data["sources"].each do |source|
    type = source["kind"].capitalize

    channel.sources.create!(url: source["url"], type: "ChannelSource::#{ type }")
    
    puts "Created: #{ channel.name } #{ type } Source"
  end
end
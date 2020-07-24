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
  channel_data["socials"].each do |social|
    type = social["kind"].capitalize

    channel.socials.create!(url: source["url"], type: "ChannelSocial::#{ type }")
    
    puts "Created: #{ channel.name } #{ type } Social"
  end
  channel_data["supports"].each do |support|
    type = support["kind"].capitalize

    channel.supports.create!(url: source["url"], type: "ChannelSupport::#{ type }")
    
    puts "Created: #{ channel.name } #{ type } Support"
  end
end
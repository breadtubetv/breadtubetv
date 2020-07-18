file = File.read("./data/channels.json")
channels = JSON.parse(file)

channels.each do |channel_data|
  channel = Channel.create!(
    name: channel_data["name"],
    description: channel_data["description"],
    slug: channel_data["slug"],
    image: channel_data["image"]
  )

  channel.sources.create!(url: channel_data["sources"][0]["url"], kind: "youtube")

  puts "Created: #{ channel.slug } Channel"
end
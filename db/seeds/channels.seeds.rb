file = File.read("./data/channels.json")
channels = JSON.parse(file)

channels.each do |channel|
  puts Channel.create(
    name: channel["name"],
    description: channel["description"],
    slug: channel["slug"],
    image: channel["image"]
  ).inspect
end
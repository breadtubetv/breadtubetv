file = File.read("./data/posts.json")
posts = JSON.parse(file)

posts.each do |post_channel|
  channel = Channel.find_by(slug: post_channel['slug'])
  post_channel["contents"].each do |post|
    puts Post.create(
      name: post["name"],
      description: post["description"],
      slug: post["slug"],
      published_at: post["published_at"],
      source_url: post["sources"][0]["url"],
      channel: channel
    ).inspect
  end
end
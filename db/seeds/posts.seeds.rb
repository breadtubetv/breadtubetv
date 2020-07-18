file = File.read("./data/posts.json")
posts = JSON.parse(file)

posts.each do |post_channel_data|
  channel = Channel.find_by(slug: post_channel_data['slug'])
  
  post_channel_data["contents"].each do |post_data|
    post = Post.create(
      name: post_data["name"],
      description: post_data["description"],
      slug: post_data["slug"],
      published_at: post_data["published_at"],
      source_url: post_data["sources"][0]["url"],
      channel: channel
    )

    puts "Created: #{ post.name } Post"
  end
end
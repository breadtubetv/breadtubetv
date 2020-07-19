after :channels do
  file = File.read("./data/videos.json")
  videos = JSON.parse(file)

  videos.each do |video_channel_data|
    channel = Channel.find_by(slug: video_channel_data['slug'])
    
    video_channel_data["contents"].each do |video_data|
      video = Video.create(
        name: video_data["name"],
        description: video_data["description"],
        slug: video_data["slug"],
        published_at: video_data["published_at"],
        channel: channel
      )

      video.sources.create!(url: video_data["sources"][0]["url"], kind: "youtube")

      puts "Created: #{ video.name } video"
    end
  end
end
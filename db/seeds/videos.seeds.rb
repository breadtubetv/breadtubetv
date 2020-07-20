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
        tags: video_channel_data["tags"],
        channel: channel
      )

      puts "Created: #{ video.name } Video"

      video_data["sources"].each do |source|
        type = source["type"].capitalize
        
        video.sources.create!(url: source["url"], type: "VideoSource::#{ type }")

        puts "Created: #{ video.name } #{ type } Source"
      end
    end
  end
end
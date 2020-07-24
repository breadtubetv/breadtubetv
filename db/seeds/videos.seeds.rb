after :channels do
  file = File.read("./data/videos.json")
  videos = JSON.parse(file)

  videos.each do |video_data|
    channel = Channel.friendly.find(video_data['channel']['slug'])

    video = channel.videos.create(
      name: video_data["name"],
      description: video_data["description"],
      slug: video_data["slug"],
      published_at: video_data["published_at"],
      tags: video_data["tags"]
    )

    if video.valid?
      puts "Created: #{ video.name } Video"

      video_data["sources"].each do |source|
        type = source["kind"].capitalize
        
        video.sources.create!(
          url: source["url"],
          type: "VideoSource::#{ type }",
          view_count: source["view_count"],
          like_count: source["like_count"],
          dislike_count: source["dislike_count"],
          favorite_count: source["favorite_count"],
          comment_count: source["comment_count"],
          duration: source["duration"],
          length: source["length"],
          scheduled: source["scheduled"],
          scheduled_at: source["scheduled_at"]
        )

        puts "Created: #{ video.name } #{ type } Source"
      end
    end
  end
end
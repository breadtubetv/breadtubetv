class ChannelSource::Youtube < ChannelSource
  after_initialize :set_youtube

  def videos
    @yt.videos
  end

  def sync!
    videos.each do |yt_video|
      video_source = video_sources.find_or_initialize_by(
        url: "https://www.youtube.com/watch?v=#{ yt_video.id }",
        type: "VideoSource::Youtube"
      )

      video = video_source.video || videos.new

      video.update!(
        name: yt_video.title,
        description: yt_video.description,
        published_at: yt_video.published_at
      )

      video_source.video = video
      video_source.save!
    end
  end

  private def set_youtube
    @yt = Yt::Channel.new(id: ident)
  end

  private def set_ident
    self.ident = url.gsub("https://www.youtube.com/channel/", "")
  end
end
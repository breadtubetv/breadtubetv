class ChannelSource::Youtube < ChannelSource
  def rss_url
    "https://www.youtube.com/feeds/videos.xml?channel_id=#{ ident }"
  end

  def api_videos
    @api_videos ||= if last_synced
                         api.videos.where(published_after: last_synced)
                       else
                         api.videos
                       end
  end

  def sync!
    api_videos.each do |yt_video|
      ActiveRecord::Base.transaction do
        puts "Syncing: #{ yt_video.title.html_safe } Video"
        video_source = channel.video_sources.find_or_initialize_by(
          url: "https://www.youtube.com/watch?v=#{ yt_video.id }",
          type: "VideoSource::Youtube"
        )

        video = video_source.video || channel.videos.new

        video.update!(
          name: yt_video.title,
          description: yt_video.description,
          published_at: yt_video.published_at
        )

        video_source.video = video
        video_source.sync!(yt_video)

        update!(synced_at: yt_video.published_at)
      end
    end

    touch(:synced_at)
  end

  private def last_synced
    synced_at&.rfc3339 || channel.videos.latest.first&.published_at
  end

  private def api
    @api ||= Yt::Channel.new(id: ident)
  end

  private def set_ident
    self.ident = url.gsub("https://www.youtube.com/channel/", "")
  end
end
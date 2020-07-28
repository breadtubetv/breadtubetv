class ChannelSource::Youtube < ChannelSource
  def rss_url
    "https://www.youtube.com/feeds/videos.xml?channel_id=#{ ident }"
  end

  def api_videos
    @api_videos ||= api.videos.where(published_after: sync_from)
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
          published_at: yt_video.published_at,
          youtube_attributes: {
            id: video_source.id,
            url: "https://www.youtube.com/watch?v=#{ yt_video.id }",
            view_count: yt_video.view_count,
            like_count: yt_video.like_count,
            dislike_count: yt_video.dislike_count,
            favorite_count: yt_video.favorite_count,
            comment_count: yt_video.comment_count,
            duration: yt_video.duration,
            length: yt_video.length,
            scheduled: yt_video.scheduled?,
            scheduled_at: yt_video.scheduled_at,
            tags: yt_video.tags
          }
        )
      end
    end

    touch(:synced_at)
  end

  private def sync_from
    (channel.videos.last&.published_at || 1.month.ago).rfc3339
  end

  private def api
    @api ||= Yt::Channel.new(id: ident)
  end

  private def set_ident
    self.ident = url.gsub("https://www.youtube.com/channel/", "")
  end
end
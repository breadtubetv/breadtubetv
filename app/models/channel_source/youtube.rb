class ChannelSource::Youtube < ChannelSource
  def rss_url
    "https://www.youtube.com/feeds/videos.xml?channel_id=#{ ident }"
  end

  def refresh!
    @xml = HTTParty.get(rss_url).body
    feed = Feedjira.parse(@xml)
    feed.entries.each do |entry|
      puts "Refreshing: #{ entry.title.html_safe } Video"

      video_source = channel.video_sources.find_or_initialize_by(
        url: entry.url,
        type: "VideoSource::Youtube"
      )

      video = video_source.video || channel.videos.new

      video.update!(
        name: entry.title,
        description: entry.content,
        published_at: entry.published,
        youtube_attributes: {
          id: video_source.id,
          url: entry.url,
          view_count: entry.media_views,
          like_count: entry.media_star_count
        } 
      )
    end

    touch(:synced_at)
  end

  def sync!
    api_videos.each do |entry|
      ActiveRecord::Base.transaction do
        puts "Syncing: #{ entry.title.html_safe } Video"

        video_source = channel.video_sources.find_or_initialize_by(
          url: "https://www.youtube.com/watch?v=#{ entry.id }",
          type: "VideoSource::Youtube"
        )

        video = video_source.video || channel.videos.new

        video.update!(
          name: entry.title,
          description: entry.description,
          published_at: entry.published_at,
          youtube_attributes: {
            id: video_source.id,
            url: "https://www.youtube.com/watch?v=#{ entry.id }",
            view_count: entry.view_count,
            like_count: entry.like_count,
            dislike_count: entry.dislike_count,
            favorite_count: entry.favorite_count,
            comment_count: entry.comment_count,
            duration: entry.duration,
            length: entry.length,
            scheduled: entry.scheduled?,
            scheduled_at: entry.scheduled_at,
            tags: entry.tags
          }
        )
      end
    end

    touch(:synced_at)
  end

  private def api_videos
    @api_videos ||= api.videos.where(published_after: sync_from)
  end

  private def sync_from
    1.month.ago.rfc3339
  end

  private def api
    @api ||= Yt::Channel.new(id: ident)
  end

  private def set_ident
    self.ident = url.gsub("https://www.youtube.com/channel/", "")
  end
end
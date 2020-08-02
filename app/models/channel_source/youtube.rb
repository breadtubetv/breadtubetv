class ChannelSource::Youtube < ChannelSource
  def rss_url
    "https://www.youtube.com/feeds/videos.xml?channel_id=#{ ident }"
  end

  def refresh!
    rss_videos.each do |entry|
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

  private def rss_feed
    begin
      xml = HTTParty.get(rss_url).body
      @rss_feed = Feedjira.parse(xml)
    rescue Feedjira::NoParserAvailable => e
      puts channel.inspect
      puts ident
      puts rss_url
      puts xml
    end
  end

  private def rss_videos
    @rss_videos = rss_feed.entries
  end

  private def api_videos
    @api_videos ||= api.videos.where(published_before: sync_to.rfc3339, published_after: sync_from.rfc3339)
  end

  private def sync_to
    channel.videos.latest.last.published_at
  end

  private def sync_from
    (sync_to - 1.month)
  end

  private def api
    @api ||= Yt::Channel.new(id: ident)
  end

  private def set_ident
    self.ident = url.to_s[/https?:\/\/w?w?w?\.?youtube\.com\/channel\/([\w,_,-]*)$?\/?\??/,1]
  end
end
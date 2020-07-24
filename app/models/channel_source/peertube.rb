class ChannelSource::Peertube < ChannelSource
  def rss_url
    "https://www.youtube.com/feeds/videos.xml?channel_id=#{ ident }"
  end

  private def set_ident
     self.ident = url.gsub("https://watch.breadtube.tv/video-channels/", "")
  end
end
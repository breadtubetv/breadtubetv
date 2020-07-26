class ChannelSource::Peertube < ChannelSource
  def rss_url
    ""
  end

  private def set_ident
    self.ident = url.gsub("https://watch.breadtube.tv/video-channels/", "").gsub(/videos$/,"").gsub(/\//,"")
  end
end
class ChannelSource::Peertube < ChannelSource
  def rss_url
    ""
  end

  private def set_ident
    self.ident = url[/https?:\/\/.*\/video-channels\/(\w*)$?\/?\??/,1]
  end
end
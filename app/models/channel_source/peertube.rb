class ChannelSource::Peertube < ChannelSource
  def rss_url
    ""
  end

  private def set_ident
    self.ident = url.to_s[/https?:\/\/.*\/video-channels\/(\w*)$?\/?\??/,1]
  end
end
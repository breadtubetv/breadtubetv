class ChannelSource::Peertube < ChannelSource
  def rss_url
    ""
  end

  private def set_ident
    self.ident = url.gsub(/https?:\/\/.*\/video-channels\//, "").gsub(/\/videos\/?$/, "")
  end
end
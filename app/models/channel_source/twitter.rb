class ChannelSource::Twitter < ChannelSource
  private def set_ident
    self.ident = url.gsub("https://www.twitter.com/", "")
  end
end
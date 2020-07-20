class ChannelSource::Facebook < ChannelSource
  private def set_ident
    self.ident = url.gsub("https://www.facebook.com/", "")
  end
end
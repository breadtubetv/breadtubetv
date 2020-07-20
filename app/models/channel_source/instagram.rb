class ChannelSource::Instagram < ChannelSource
  private def set_ident
    self.ident = url.gsub("https://www.instagram.com/", "")
  end
end
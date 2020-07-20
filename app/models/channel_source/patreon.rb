class ChannelSource::Patreon < ChannelSource
  private def set_ident
    self.ident = url.gsub("https://www.patreon.com/", "")
  end
end
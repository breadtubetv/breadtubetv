class ChannelSource::Kofi < ChannelSource
  private def set_ident
    self.ident = url.gsub("https://www.ko-fi.com/", "")
  end
end
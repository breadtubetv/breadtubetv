class ChannelSource::Twitch < ChannelSource
  private def set_ident
    self.ident = url.gsub("https://www.twitch.tv/", "")
  end
end
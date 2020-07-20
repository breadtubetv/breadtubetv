class ChannelSource::Discord < ChannelSource
  private def set_ident
    self.ident = url.gsub("https://www.discord.gg/", "")
  end
end
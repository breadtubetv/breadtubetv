class ChannelSocial::Discord < ChannelSocial
  private def set_ident
    self.ident = url.gsub("https://www.discord.gg/", "")
  end
end
class ChannelSocial::Twitch < ChannelSocial
  private def set_ident
    self.ident = url.gsub("https://www.twitch.tv/", "")
  end
end
class ChannelSocial::Twitter < ChannelSocial
  private def set_ident
    self.ident = url.gsub("https://www.twitter.com/", "")
  end
end
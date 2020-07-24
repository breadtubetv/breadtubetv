class ChannelSocial::Instagram < ChannelSocial
  private def set_ident
    self.ident = url.gsub("https://www.instagram.com/", "")
  end
end
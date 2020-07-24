class ChannelSocial::Speaker < ChannelSocial
  private def set_ident
    self.ident = url.gsub("https://www.spreaker.com/user/","")
  end
end
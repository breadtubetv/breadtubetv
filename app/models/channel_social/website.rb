class ChannelSocial::Website < ChannelSocial
  private def set_ident
    self.ident = url
  end
end
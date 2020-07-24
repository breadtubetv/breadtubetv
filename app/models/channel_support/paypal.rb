class ChannelSupport::Paypal < ChannelSupport
  private def set_ident
    self.ident = url
  end
end
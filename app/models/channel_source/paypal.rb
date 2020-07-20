class ChannelSource::Paypal < ChannelSource
  private def set_ident
    self.ident = url
  end
end
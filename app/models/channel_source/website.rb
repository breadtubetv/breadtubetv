class ChannelSource::Website < ChannelSource
  private def set_ident
    self.ident = url
  end
end
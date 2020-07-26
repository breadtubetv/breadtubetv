class ChannelSupport::Liberapay < ChannelSupport
  private def set_ident
    self.ident = url.gsub("https://liberapay.com/", "")
  end
end
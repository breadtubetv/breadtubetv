class ChannelSource::Youtube < ChannelSource
  after_initialize :set_youtube

  def videos
    @yt.videos
  end

  private def set_youtube
    @yt = Yt::Channel.new(id: ident)
  end

  private def set_ident
    self.ident = url.gsub("https://www.youtube.com/channel/", "")
  end
end
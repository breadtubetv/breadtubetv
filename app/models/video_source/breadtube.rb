class VideoSource::Breadtube < VideoSource
  def image
    "https://watch.breadtube.tv/static/thumbnails/#{ ident }.jpg"
  end

  def embed_url
    "https://watch.breadtube.tv/videos/embed/#{ ident }"
  end

  private def set_ident
    self.ident = url.gsub("https://watch.breadtube.tv/videos/watch/", "")
  end
end
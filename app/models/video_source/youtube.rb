class VideoSource::Youtube < VideoSource
  def image
    "https://img.youtube.com/vi/#{ ident }/hqdefault.jpg"
  end

  def embed_url
    "https://www.youtube.com/embed/#{ ident }"
  end

  private def set_ident
    self.ident = url.gsub("https://www.youtube.com/watch?v=", "")
  end
end
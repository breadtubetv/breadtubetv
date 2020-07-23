class VideoSource::Youtube < VideoSource
  def image
    "https://img.youtube.com/vi/#{ ident }/hqdefault.jpg"
  end

  def embed_url
    "https://www.youtube.com/embed/#{ ident }"
  end

  def sync!(data = nil)
    data ||= api

    update!(
      view_count: data.view_count,
      like_count: data.like_count,
      dislike_count: data.dislike_count,
      favorite_count: data.favorite_count,
      comment_count: data.comment_count,
      duration: data.duration,
      length: data.length,
      scheduled: data.scheduled?,
      scheduled_at: data.scheduled_at,
      tags: data.tags
    )
  end

  private def api
    @api ||= Yt::Video.new(id: ident)
  end

  private def set_ident
    self.ident = url.gsub("https://www.youtube.com/watch?v=", "")
  end
end
class VideoSource::Youtube < VideoSource
  def image
    "https://img.youtube.com/vi/#{ ident }/hqdefault.jpg"
  end

  def embed_url
    "https://www.youtube.com/embed/#{ ident }"
  end

  def sync!
    update!(
      view_count: api.view_count,
      like_count: api.like_count,
      dislike_count: api.dislike_count,
      favorite_count: api.favorite_count,
      comment_count: api.comment_count,
      duration: api.duration,
      length: api.length,
      scheduled: api.scheduled?,
      scheduled_at: api.scheduled_at,
      tags: api.tags
    )
  end

  private def api
    @api ||= Yt::Video.new(id: ident)
  end

  private def set_ident
    self.ident = url.gsub("https://www.youtube.com/watch?v=", "")
  end
end
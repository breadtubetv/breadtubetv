json.extract! video, :id, :name, :slug, :description, :published_at, :channel, :created_at, :updated_at, :tags
json.sources(video.sources) do |source|
  json.extract! source, :url, :kind, :view_count, :like_count, :dislike_count, :favorite_count, :comment_count, :duration, :length, :scheduled, :scheduled_at
end
json.url channel_video_url(video.channel, video, format: :json)

json.extract! video, :id, :name, :slug, :description, :published_at, :channel, :created_at, :updated_at, :tags
json.sources(video.sources) do |source|
  json.extract! source, :url, :kind
end
json.url video_url(video, format: :json)

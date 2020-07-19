json.extract! video, :id, :name, :slug, :description, :published_at, :channel, :created_at, :updated_at
json.url video_url(video, format: :json)

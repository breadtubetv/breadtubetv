json.extract! channel, :id, :name, :slug, :description, :image, :created_at, :updated_at, :tags
json.sources(channel.sources) do |source|
  json.extract! source, :url, :kind
end
json.url channel_url(channel, format: :json)

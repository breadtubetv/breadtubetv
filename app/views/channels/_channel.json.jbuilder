json.extract! channel, :id, :name, :slug, :description, :image, :created_at, :updated_at
json.url channel_url(channel, format: :json)

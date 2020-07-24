json.extract! channel_social, :id, :channel, :url, :ident, :created_at, :updated_at
json.url channel_social_url(channel_social, format: :json)

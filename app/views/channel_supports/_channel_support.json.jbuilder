json.extract! channel_support, :id, :channel, :url, :ident, :created_at, :updated_at
json.url channel_support_url(channel_support, format: :json)

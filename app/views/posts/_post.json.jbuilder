json.extract! post, :id, :name, :slug, :description, :published_at, :kind, :source_url, :channel_id, :created_at, :updated_at
json.url post_url(post, format: :json)

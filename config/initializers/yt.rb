Yt.configure do |config|
  config.log_level = :debug
  config.api_key = ENV.fetch('YOUTUBE_API_KEY', '')
  config.client_id = ENV.fetch('YOUTUBE_CLIENT_ID', '')
  config.client_secret = ENV.fetch('YOUTUBE_CLIENT_SECRET', '')
end
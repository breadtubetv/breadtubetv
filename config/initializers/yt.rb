Yt.configure do |config|
  config.api_key = ENV.fetch('YOUTUBE_API_KEY')
  config.log_level = :debug
end
if Rails.env.development?
  PEERTUBE_AUTH = {}

  client_url = "https://watch.breadtube.tv/api/v1/oauth-clients/local"
  client_uri = URI(client_url)
  client_response = Net::HTTP.get(client_uri)
  PEERTUBE_AUTH.merge(JSON.parse(client_response))

  token_url = "https://watch.breadtube.tv/api/v1/users/token"
  token_uri = URI(token_url)
  token_response = Net::HTTP.post_form(token_uri, {
    "response_type": "code",
    "grant_type": "password",
    "client_id": PEERTUBE_AUTH["client_id"],
    "client_secret": PEERTUBE_AUTH["client_secret"],
    "username": ENV.fetch("PEERTUBE_USERNAME", ""),
    "password": ENV.fetch("PEERTUBE_PASSWORD", ""),
  })
  PEERTUBE_AUTH.merge(JSON.parse(token_response.body))

  Peertube.configure do |config|
    config.access_token = PEERTUBE_AUTH["access_token"]
  end
end
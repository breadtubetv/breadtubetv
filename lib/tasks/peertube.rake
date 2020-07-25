desc "Manage PeerTube"

namespace :peertube do
  task :videos => [:environment] do |task, args|
    api_instance = Peertube::VideoApi.new

    begin
      result = api_instance.videos_get({})
      p result
    rescue Peertube::ApiError => e
      puts "Exception when calling VideoApi->videos_get: #{e}"
    end
  end
end
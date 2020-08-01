namespace :breadtube do
  namespace :heroku do
    desc "Reset the Heroku database and reseed with data/"
    task :reset => [:environment] do
      `heroku run rake db:schema:load DISABLE_DATABASE_ENVIRONMENT_CHECK=1 db:seed`
    end

    desc "Pull down Heroku database"
    task :pull => [:environment] do
      `./scripts/heroku_pull.sh`
    end
  end

  namespace :import do
    task :youtube, [:channel, :url] => [:environment] do |task, args|
      channel = Channel.friendly.find(args[:channel])
      if channel.youtube
        puts "Exists: #{ channel.name } - #{ source.url }"
      else
        channel.create_youtube(url: args[:url])
        puts "Imported: #{ channel.name } - #{ source.url }"
      end
    end

    desc "Assign Channel from PeerTube"
    task :assign, [:channel, :url] => [:environment] do |task, args|
      channel = Channel.friendly.find(args[:channel])
      source = channel.peertube || channel.create_peertube(
        url: args[:url]
      )
      puts "Imported: #{ channel.name } - #{ source.url }"
    end
  end

  namespace :refresh do
    desc "Refresh Channel from RSS Feed"
    task :channel, [:slug] => [:environment] do |task, args|
      channel = Channel.friendly.find(args[:slug])
      channel.refresh!
    end

    desc "Refresh all Channels from RSS Feed"
    task :channels => [:environment] do
      Channel.kept.order_by_oldest.each do |channel|
        channel.refresh!
        puts "Refreshed: #{ channel.name } Channel"
        sleep(3)
      end
    end
  end

  namespace :sync do
    desc "Sync Channel from API"
    task :channel, [:slug] => [:environment] do |task, args|
      channel = Channel.friendly.find(args[:slug])
      channel.sync!
      puts "Synced: #{ channel.name} Channel"
    end

    desc "Sync all Channels from API"
    task :channels => [:environment] do
      Channel.kept.random.needs_videos.needs_sync.each do |channel|
        channel.sync!
        puts "Synced: #{ channel.name } Channel"
        sleep(10)
      end
    end
  end

  desc "PeerTube"
  namespace :peertube do
    desc "Import Channel from PeerTube"
    task :import, [:channel] => [:environment] do |task, args|
      channel = Channel.friendly.find(args[:channel])

      video_api = Peertube::VideoApi.new

      begin
        result = video_api.video_channels_channel_handle_videos_get(channel.peertube.ident)
        
        result.data.each do |video_source|
          video = channel.videos.find_by(name: video_source.name)
          if video
            source = video.peertube || video.create_peertube(
              url: "https://watch.breadtube.tv/videos/watch/#{video_source.uuid}"
            )
            puts "Import: #{ video.name } - #{ source.ident }"
          else
            puts "No Video #{ video_source.name }"
          end
        end
      rescue Peertube::ApiError => e
        puts "Exception when calling VideoApi->videos_get: #{e}"
      end
    end
  end

  namespace :youtube do
    desc "Create or Update Channel from YouTube"
    task :import, [:url] => [:environment] do |task, args|
      url = args[:url]
      ident = url.gsub("https://www.youtube.com/channel/","")
      image_hash = SecureRandom.hex(16)
      image_path = "/channels/#{ image_hash }.jpg"

      yt = Yt::Channel.new(id: ident)

      if channel_source = ChannelSource.find_by(url: url)
        @channel = channel_source.channel

        puts "Channel: #{ @channel.name } Exists"
      else
        @channel = Channel.new(
          name: yt.title,
          description: yt.description,
          image: image_path,
          sources: [
            ChannelSource.new(
              type: "ChannelSource::Youtube",
              url: url
            )
          ]
        )

        if @channel.save!
          URI.open(yt.thumbnail_url) do |image|
            File.open("public#{ image_path }", "wb") do |file|
              file.write(image.read)
            end
          end

          puts "Channel: #{ @channel.name } Created!"
        end
      end
    end
  end

  desc "Download channels.json and videos.json to data/ folder"
  task :backup => ["backup:channels", "backup:videos"]

  namespace :backup do
    desc "Download channels.json to data/ folder"
    task :channels => [:environment] do
      `curl localhost:3000/channels.json?items=100000 > data/channels.json`
    end

    desc "Download videos.json to data/ folder"
    task :videos => [:environment] do
      `curl localhost:3000/videos.json?items=100000 > data/videos.json`
    end
  end
end
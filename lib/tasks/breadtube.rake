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
    task :file, [:file] => [:environment] do |task, args|
      File.foreach(args[:file]).with_index do |line, index|
        Rake::Task["breadtube:import:youtube"].invoke(line.strip)
        Rake::Task["breadtube:import:youtube"].reenable
      end
    end

    task :youtube, [:url] => [:environment] do |task, args|
      channel_source = ChannelSource::Youtube.find_or_initialize_by(url: args[:url])

      if channel_source.persisted?
        @channel = channel_source.channel

        puts "Exists: #{ @channel.name }"
      else
        begin
          yt = Yt::Channel.new(id: channel_source.ident)

          @channel = Channel.new(
            name: yt.title,
            description: yt.description,
            youtube: channel_source
          )

          image_path = "/channels/#{ @channel.slug }.jpg"

          @channel.image = image_path

          if @channel.save!
            puts "Created: #{ @channel.name } Channel"

            if Rails.env.development?
              URI.open(yt.thumbnail_url(:high)) do |image|
                File.open("public#{ image_path }", "wb") do |file|
                  file.write(image.read)
                end
              end
              puts "Downloaded: #{ @channel.image }"
            end
          end
        rescue Yt::Errors::NoItems
          puts "Doesn't Exist: #{ channel_source.url }"
        end
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

  namespace :images do
    task :youtube => [:environment] do
      ChannelSource::Youtube.all.each do |source|
        yt = Yt::Channel.new(id: source.ident)

        URI.open(yt.thumbnail_url(:high)) do |image|
          File.open("public#{ source.channel.image }", "wb") do |file|
            file.write(image.read)
          end
          puts "Downloaded: #{ source.channel.image }"
        end
      end
    end
  end
end
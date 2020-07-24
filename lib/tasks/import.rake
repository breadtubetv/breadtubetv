desc "Import Objects"

namespace :import do
  task :channel, [:youtube] => [:environment] do |task, args|
    url = args[:youtube]
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

    @channel.sync!
    puts "Channel: #{ @channel.name } Synced!"
  end
end

namespace :sync do
  task :channels, [:slug] => [:environment] do |task, args|
    channel = Channel.friendly.find(args[:slug])
    channel.sync!
    puts "Channel: #{ channe.name} Synced!"
  end

  task :channels => [:environment] do
    Channel.order_by_oldest.where('updated_at > ?', 1.days.ago.to_date.end_of_day).each do |channel|
      channel.sync!
      puts "Channel: #{ channel.name } Synced!"
      sleep(10)
    end
  end
end

task :backup => ["backup:channels", "backup:videos"]

namespace :backup do
  task :channels => [:environment] do
    `curl localhost:3000/channels.json?items=100000 > data/channels.json`
  end

  task :videos => [:environment] do
    `curl localhost:3000/videos.json?items=100000 > data/videos.json`
  end
end
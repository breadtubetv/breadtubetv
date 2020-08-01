class ChannelsUseImageSlug < ActiveRecord::Migration[6.0]
  def change
    Channel.all.each do |channel|
      channel.update(image: "/channels/#{ channel.slug }.jpg")
    end
  end
end

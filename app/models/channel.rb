require 'rss'
require 'open-uri'

class Channel < ApplicationRecord
  has_many :features, dependent: :destroy

  has_many :videos, dependent: :destroy
  has_many :video_sources, through: :videos, source: :sources

  has_many :sources, class_name: "::ChannelSource", dependent: :destroy
  has_one :youtube, class_name: "::ChannelSource::Youtube"

  def to_param
    slug
  end

  def sync!
    youtube.videos.each do |yt_video|
      puts "yt_video.inspect"
      video_source = video_sources.find_or_initialize_by(
        url: "https://www.youtube.com/watch?v=#{ yt_video.id }",
        type: "VideoSource::Youtube"
      )

      video = video_source.video || videos.new

      video.update!(
        name: yt_video.title,
        description: yt_video.description,
        published_at: yt_video.published_at
      )

      video_source.video = video
      video_source.save!
    end

    self.touch
  end
end

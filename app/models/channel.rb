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
    youtube.sync!

    self.touch
  end
end

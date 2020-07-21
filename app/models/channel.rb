require 'rss'
require 'open-uri'

class Channel < ApplicationRecord
  after_initialize :set_slug

  has_many :features, dependent: :destroy

  has_many :videos, dependent: :destroy
  has_many :video_sources, through: :videos, source: :sources

  has_many :sources, class_name: "::ChannelSource", dependent: :destroy
  has_one :youtube, class_name: "::ChannelSource::Youtube"

  validates :name, :slug, presence: true, uniqueness: true

  scope :order_by_oldest, -> { order(updated_at: :asc) }

  def to_param
    slug
  end

  def sync!
    youtube.sync!

    self.touch
  end

  private def set_slug
    self.slug ||= name.parameterize
  end
end

class Channel < ApplicationRecord
  extend FriendlyId

  after_initialize :set_slug

  has_many :features, dependent: :destroy

  has_many :videos, dependent: :destroy
  has_many :video_sources, through: :videos, source: :sources

  has_many :sources, class_name: "::ChannelSource", dependent: :destroy
  has_one :peertube, class_name: "::ChannelSource::Peertube"
  has_one :youtube, class_name: "::ChannelSource::Youtube"

  has_many :socials, class_name: "::ChannelSocial", dependent: :destroy
  has_many :supports, class_name: "::ChannelSupport", dependent: :destroy

  validates :name, :slug, presence: true, uniqueness: true

  scope :order_by_slug, -> { order(slug: :asc) }
  scope :order_by_oldest, -> { order(updated_at: :asc) }
  scope :order_by_latest, -> { order(published_at: :desc) }
  scope :random, -> { order("RANDOM()") }
  scope :needs_update, -> { where(updated_at: ..1.day.ago) }
  scope :needs_sync, -> { joins(:sources).merge(ChannelSource.needs_sync).order("channel_sources.synced_at desc") }
  scope :needs_videos, -> { includes(:videos).where(videos: { channel_id: nil} ) }

  friendly_id :name

  def to_s
    name
  end

  def refresh!
    youtube.refresh!

    self.touch
  end

  def sync!
    youtube.sync!

    self.touch
  end

  def normalize_friendly_id(string)
    super.gsub("-", "")
  end
end
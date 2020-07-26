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
  scope :needs_sync, -> { joins(:sources).merge(ChannelSource.needs_sync) }

  friendly_id :name

  def to_s
    name
  end

  def sync!
    youtube.sync!
  end

  def normalize_friendly_id(string)
    super.gsub("-", "")
  end
end
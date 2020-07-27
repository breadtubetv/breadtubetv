class Video < ApplicationRecord
  extend FriendlyId

  before_save :set_slug

  belongs_to :channel

  has_many :sources, class_name: "VideoSource", dependent: :destroy
  has_one :peertube, class_name: "VideoSource::Peertube"
  has_one :youtube, class_name: "VideoSource::Youtube"

  scope :published, -> { where.not(published_at: nil) }
  scope :latest, -> { order(published_at: :desc) }
  scope :random, -> { order("RANDOM()") }
  scope :this_week, -> { where(published_at: 1.week.ago..1.second.ago) }

  validates :slug, uniqueness: { scope: :channel_id }

  friendly_id :name, use: :scoped, scope: :channel

  def to_s
    name
  end

  def image
    youtube&.image || VIDEO_PLACEHOLDER_IMAGE
  end

  def sync!
    youtube.sync!

    self.touch
  end
end

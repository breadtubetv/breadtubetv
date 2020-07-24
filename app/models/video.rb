class Video < ApplicationRecord
  extend FriendlyId

  before_save :set_slug

  belongs_to :channel

  has_many :sources, class_name: "VideoSource", dependent: :destroy
  has_one :youtube, class_name: "VideoSource::Youtube"
  has_one :breadtube, class_name: "VideoSource::Breadtube"

  scope :published, -> { where.not(published_at: nil) }
  scope :latest, -> { order(published_at: :desc) }
  scope :random, -> { order("RANDOM()") }

  validates :slug, uniqueness: { scope: :channel_id }

  friendly_id :name, use: :scoped, scope: :channel

  def to_s
    name
  end

  def image
    youtube.image
  rescue
    raise id.inspect
  end

  def sync!
    youtube.sync!

    self.touch
  end
end

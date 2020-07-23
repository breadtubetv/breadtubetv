class Video < ApplicationRecord
  after_initialize :set_slug

  belongs_to :channel

  has_many :sources, class_name: "VideoSource", dependent: :destroy
  has_one :youtube, class_name: "VideoSource::Youtube"

  scope :published, -> { where.not(published_at: nil) }
  scope :latest, -> { order(published_at: :desc) }
  scope :random, -> { order("RANDOM()") }

  def to_param
    slug
  end

  def image
    youtube.image
  end

  private def set_slug
    self.slug ||= "#{channel.slug}/#{name&.parameterize}/#{id}".html_safe
  end
end

class Video < ApplicationRecord
  belongs_to :channel

  has_many :sources, class_name: "VideoSource", dependent: :destroy
  has_one :youtube, class_name: "VideoSource::Youtube"

  scope :published, -> { where.not(published_at: nil) }
  scope :latest, -> { order(published_at: :desc) }
  scope :random, -> { order("RANDOM()") }

  def name
    self[:name]&.gsub(/#{channel.name}/i, "")&.gsub(" - ","")&.gsub(" |  | "," | ")&.gsub("  "," ")&.split.map(&:capitalize).join(' ')
  end

  def image
    youtube.image
  end
end

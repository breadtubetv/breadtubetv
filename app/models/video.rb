class Video < ApplicationRecord
  belongs_to :channel

  has_many :sources, class_name: "VideoSource", dependent: :destroy

  def image
    "https://img.youtube.com/vi/#{ source_id }/hqdefault.jpg"
  end

  def source_id
    sources.first.url.gsub("https://www.youtube.com/watch?v=", "")
  end
end

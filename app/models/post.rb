class Post < ApplicationRecord
  belongs_to :channel

  def image
    "https://img.youtube.com/vi/#{ source_id }/hqdefault.jpg"
  end

  def source_id
    source_url.gsub("https://www.youtube.com/watch?v=", "")
  end
end

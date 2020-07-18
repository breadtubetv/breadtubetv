class Post < ApplicationRecord
  belongs_to :channel

  def source_id
    source_url.gsub("https://www.youtube.com/watch?v=", "")
  end
end

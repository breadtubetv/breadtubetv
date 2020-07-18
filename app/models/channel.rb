class Channel < ApplicationRecord
  has_many :sources, class_name: "ChannelSource"
  has_many :posts

  def to_param
    slug
  end
end

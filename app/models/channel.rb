class Channel < ApplicationRecord
  has_many :features, dependent: :destroy

  has_many :videos, dependent: :destroy

  has_many :sources, class_name: "ChannelSource", dependent: :destroy

  def to_param
    slug
  end
end

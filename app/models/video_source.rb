class VideoSource < ApplicationRecord
  before_create :set_ident

  belongs_to :video

  scope :order_by_type, -> { order(type: :asc) }

  def kind
    type.to_s.gsub("VideoSource::", "").downcase
  end

  private def set_ident
    raise NotImplementedError
  end
end

class VideoSource < ApplicationRecord
  before_create :set_ident

  belongs_to :video

  def kind
    type.to_s.gsub("VideoSource::", "").downcase
  end

  private def set_ident
    raise NotImplementedError
  end
end

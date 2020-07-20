class VideoSource < ApplicationRecord
  before_create :set_ident

  belongs_to :video

  private def set_ident
    raise NotImplementedError
  end
end

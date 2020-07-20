class ChannelSource < ApplicationRecord
  belongs_to :channel
  before_create :set_ident

  private def set_ident
    raise NotImplementedError
  end
end

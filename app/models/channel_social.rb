class ChannelSocial < ApplicationRecord
  belongs_to :channel
  before_create :set_ident

  scope :order_by_type, -> { order(type: :asc) }
  
  def kind
    type.to_s.gsub("ChannelSocial::", "").downcase
  end

  private def set_ident
    raise NotImplementedError
  end
end

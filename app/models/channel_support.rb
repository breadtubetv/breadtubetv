class ChannelSupport < ApplicationRecord
  belongs_to :channel
  before_create :set_ident

  scope :order_by_type, -> { order(type: :asc) }
  
  def kind
    type.to_s.gsub("ChannelSupport::", "").downcase
  end

  private def set_ident
    raise NotImplementedError
  end
end

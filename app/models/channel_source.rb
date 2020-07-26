class ChannelSource < ApplicationRecord
  belongs_to :channel
  before_create :set_ident

  scope :order_by_type, -> { order(type: :asc) }
  scope :needs_sync, -> { where(synced_at: ..1.day.ago) }

  def self.default_scope
    order_by_type
  end

  def to_builder
    Jbuilder.new do |source|
      source.(self, :type)
    end
  end

  def kind
    type.to_s.gsub("ChannelSource::", "").downcase
  end

  private def set_ident
    raise NotImplementedError
  end
end

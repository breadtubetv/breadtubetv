class ChannelSource < ApplicationRecord
  belongs_to :channel
  before_create :set_ident

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

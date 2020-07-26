class Feature < ApplicationRecord
  belongs_to :channel

  scope :random, -> { order("RANDOM()") }
end

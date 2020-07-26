class PagesController < ApplicationController
  layout "text", only: [:about, :privacy]

  def home
    @latest_videos = Video.includes(:channel, :sources, :youtube).published.latest.limit(12)
    @features = Feature.includes(:channel, { channel: :sources }).all.limit(12)
    @random_videos = Video.includes(:channel, :sources, :youtube).published.random.limit(24)
  end
end

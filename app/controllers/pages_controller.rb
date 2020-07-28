class PagesController < ApplicationController
  layout "text", only: [:about, :privacy]

  def home
    @latest_videos = Video.includes(:channel, :sources, :youtube).published.random.this_week.limit(12)
    @random_videos = Video.includes(:channel, :sources, :youtube).published.random.limit(12)
    @random_channels = Channel.includes(:sources).random.limit(12)
  end
end

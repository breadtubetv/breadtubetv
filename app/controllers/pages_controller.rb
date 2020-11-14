class PagesController < ApplicationController
  layout "text", except: [:home]

  def home
    @latest_videos = Video.kept.includes(:channel, :sources, :youtube).published.random.this_week.limit(12)
    @latest_channels = Channel.kept.includes(:sources).order_by_created.limit(12)
    @random_videos = Video.kept.includes(:channel, :sources, :youtube).published.random.limit(12)
    @random_channels = Channel.kept.includes(:sources).random.limit(12)
  end
end

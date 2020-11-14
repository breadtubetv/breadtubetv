class PagesController < ApplicationController
  ROW_COUNT=12

  layout "text", except: [:home]

  def home
    @latest_videos = Video.kept.includes(:channel, :sources, :youtube).published.random.this_week.limit(ROW_COUNT)
    @latest_channels = Channel.kept.includes(:sources).order_by_created.limit(ROW_COUNT)
    @random_videos = Video.kept.includes(:channel, :sources, :youtube).published.random.limit(ROW_COUNT)
    @random_channels = Channel.kept.includes(:sources).random.limit(ROW_COUNT)
  end
end

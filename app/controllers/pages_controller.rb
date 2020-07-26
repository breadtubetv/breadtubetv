class PagesController < ApplicationController
  layout "text", only: [:about, :privacy]

  def home
    @latest_videos = Video.published.latest.limit(12).includes(:channel, :sources)
    @features = Feature.all.limit(12).includes(:channel)
    @random_videos = Video.published.random.limit(24).includes(:channel, :sources)
  end
end

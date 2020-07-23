class PagesController < ApplicationController
  def home
    @latest_videos = Video.published.latest.limit(12).includes(:channel, :sources)
    @features = Feature.all.limit(12).includes(:channel)
    @random_videos = Video.published.random.limit(24).includes(:channel, :sources)
  end

  def privacy
  end
end

class PagesController < ApplicationController
  def home
    @features = Feature.all.includes(:channel)
    @random_videos = Video.published.random.limit(12).includes(:channel, :sources)
    @latest_videos = Video.published.latest.limit(12).includes(:channel, :sources)
  end

  def privacy
  end
end

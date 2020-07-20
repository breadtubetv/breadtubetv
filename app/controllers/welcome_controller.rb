class WelcomeController < ApplicationController
  def index
    @features = Feature.all.includes(:channel)
    @random_videos = Video.order("RANDOM()").limit(12).includes(:channel, :sources)
    @latest_videos = Video.published.latest.limit(12).includes(:channel, :sources)
  end
end

class WelcomeController < ApplicationController
  def index
    @features = Feature.all.includes(:channel)
    @videos = Video.order("RANDOM()").limit(10)
  end
end

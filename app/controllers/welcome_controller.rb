class WelcomeController < ApplicationController
  def index
    @features = Feature.all.includes(:channel)
    @posts = Post.order("RANDOM()").limit(10)
  end
end

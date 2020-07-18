class WelcomeController < ApplicationController
  def index
    @features = Feature.all.includes(:channel)
  end
end

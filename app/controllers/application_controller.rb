class ApplicationController < ActionController::Base
  include Pagy::Backend

  private def not_production
    if Rails.env.production?
      raise ActiveRecord::RecordNotFound
    end
  end
end

module ApplicationHelper
  include Pagy::Frontend

  def current_class?(test_path)
    'active' if request.path.include?(test_path)
  end
end

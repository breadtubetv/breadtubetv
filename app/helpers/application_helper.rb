module ApplicationHelper
  include Pagy::Frontend

  def current_class?(test_path)
    'active' if request.path.include?(test_path)
  end

  def card_row(&block)
    content_tag(:div, nil, class: "row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-6 row-cols-xl-9", &block)
  end
end

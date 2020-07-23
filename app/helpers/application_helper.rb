module ApplicationHelper
  include Pagy::Frontend

  def logo_tag(image, float: "right")
    image_tag(image, class: "float-#{float} mt-1 mr-1 rounded-circle", style: "width: 40px")
  end

  def current_class?(test_controller)
    'active' if controller_name.to_sym == test_controller
  end

  def card_row(&block)
    content_tag(:div, nil, class: "row row-cols-1 row-cols-sm-2 row-cols-md-4 row-cols-xl-6", &block)
  end
end

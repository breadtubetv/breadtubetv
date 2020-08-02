module ApplicationHelper
  include Pagy::Frontend

  def logo_tag(objekt, float: "left", width: "42px")
    image_tag(objekt.image, class: "float-#{float} mt-1 mr-1 rounded-circle", style: "width: #{ width }", alt: objekt.name)
  end

  def current_class?(test_controller)
    'active' if controller_name.to_sym == test_controller
  end

  def card_row(&block)
    content_tag(:div, nil, class: "card-row row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 row-cols-xl-6", &block)
  end

  def text_to_true_link(tweet_text)
    urls = tweet_text.scan(/https*:\/\/\w+/)
    urls.each do |url|
      tweet_text.gsub!(url, "<a href=#{url} target='_blank'>#{url}</a>")
    end
    tweet_text.html_safe
  end
end

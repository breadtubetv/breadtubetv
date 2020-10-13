xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title(@feed_title)
    xml.link(@url)
    xml.description "BreadTube.tv: Recent Videos"
    xml.language "en-us"
    xml.ttl "40"

    @videos.each do |video|
      xml.item do
        xml.title(video.name)
        xml.description(video.description)
        xml.pubDate(video.published_at.to_s(:iso))
        xml.link(channel_video_url(video.channel, video))
      end
    end
  end
end
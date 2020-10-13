xml.instruct!
xml.rss version: '2.0', 'xmlns:atom': 'http://www.w3.org/2005/Atom' do
  xml.channel do
    xml.title("BreadTube.tv")
    xml.link(root_url)
    xml.description "BreadTube.tv: Videos Feed"
    xml.language "en"
    xml.tag! 'atom:link', rel: 'self', type: 'application/rss+xml', href: videos_url(format: :xml)

    @videos.each do |video|
      xml.item do
        xml.title video.name
        xml.link channel_video_url(video.channel, video)
        xml.description video.description
        xml.pubDate video.published_at.rfc822
        xml.guid channel_video_url(video.channel, video)
      end
    end
  end
end
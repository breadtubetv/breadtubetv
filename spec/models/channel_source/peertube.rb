require "rails_helper"

RSpec.describe ChannelSource::Peertube do
  fixtures :channels

  let(:channel) { channels(:one) }
  let(:channel_source) { ChannelSource::Peertube.new(channel: channel) }

  before do
    allow(channel_source).to receive(:save) { true }
  end

  describe "#rss_url" do

    it "returns a blank string apparently" do
      expect(channel_source.rss_url).to eq ""
    end

  end

  describe "#before_create" do
    let(:ident) { "dirkkellycom" }

    it "removes the BreadTube.tv url wrapper and returns the identifier" do
      channel_source.url = "https://watch.breadtube.tv/video-channels/#{ ident }/videos"
      channel_source.save!
      expect(channel_source.ident).to eq ident
    end

    it "strips trailing slash" do
      channel_source.url = "https://watch.breadtube.tv/video-channels/#{ ident }/videos/"
      channel_source.save!
      expect(channel_source.ident).to eq ident
    end

    it "strips trailing slash" do
      channel_source.url = "https://peertube.video/video-channels/#{ ident }/videos/"
      channel_source.save!
      expect(channel_source.ident).to eq ident
    end

    it "supports non https urls" do
      channel_source.url = "http://peertube.video/video-channels/#{ ident }/videos/"
      channel_source.save!
      expect(channel_source.ident).to eq ident
    end
  end

end
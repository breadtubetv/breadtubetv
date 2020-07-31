require "rails_helper"

RSpec.describe ChannelSource::Youtube do
  fixtures :channels

  let(:channel) { channels(:one) }
  let(:channel_source) { ChannelSource::Youtube.new(channel: channel) }

  before do
    allow(channel_source).to receive(:save) { true }
  end

  describe "#rss_url" do
    let(:ident) { "UC6YURf7CpM2hH1AxxbelTrg" }

    before do
      allow(channel_source).to receive(:ident) { ident }
    end

    it "returns a blank string apparently" do
      expect(channel_source.rss_url).to eq "https://www.youtube.com/feeds/videos.xml?channel_id=#{ ident }"
    end

  end

  describe "#before_create" do
    let(:ident) { "UC6YURf7CpM2hH1AxxbelTrg" }

    it "extracts the ident from the peertube url" do
      channel_source.url = "https://www.youtube.com/channel/#{ ident }"
      channel_source.save!
      expect(channel_source.ident).to eq ident
    end

    it "strips trailing slash" do
      channel_source.url = "https://www.youtube.com/channel/#{ ident }/"
      channel_source.save!
      expect(channel_source.ident).to eq ident
    end

    it "strips trailing params" do
      channel_source.url = "https://www.youtube.com/channel/#{ ident }?view_as=subscriber"
      channel_source.save!
      expect(channel_source.ident).to eq ident
    end

    it "strips trailing paths" do
      channel_source.url = "https://www.youtube.com/channel/#{ ident }/featured"
      channel_source.save!
      expect(channel_source.ident).to eq ident
    end

    it "strips trailing paths and params" do
      channel_source.url = "https://www.youtube.com/channel/#{ ident }/featured?view_as=subscriber"
      channel_source.save!
      expect(channel_source.ident).to eq ident
    end

    it "supports non www urls" do
      channel_source.url = "https://youtube.com/channel/#{ ident }"
      channel_source.save!
      expect(channel_source.ident).to eq ident
    end

    it "supports non https urls" do
      channel_source.url = "http://www.youtube.com/channel/#{ ident }"
      channel_source.save!
      expect(channel_source.ident).to eq ident
    end

    it "supports non www non https urls with trailing slash" do
      channel_source.url = "http://youtube.com/channel/#{ ident }/"
      channel_source.save!
      expect(channel_source.ident).to eq ident
    end
  end

end
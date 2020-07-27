require "rails_helper"

RSpec.describe Video do
  let(:video) { Video.new }

  describe "#to_s" do
    let(:test_string) { "Test String" }

    it "returns name" do
      video.name = test_string
      expect(video.to_s).to eq(test_string)
    end
  end

  describe "#image" do
    context "Video has a YouTube source" do
      let(:youtube) { double(:youtube, image: image) }

      before do
        allow(video).to receive(:youtube) { youtube }
      end

      context "YouTube Source has an image" do
        let(:image) { "https://example.com/image.jpg" }

        it "returns the YouTube Source Image" do
          expect(video.image).to eq(image)
        end
      end

      context "YouTube Source doesn't have an image" do
        let(:image) { nil }

        it "returns the Video Image Placeholder" do
          expect(video.image).to eq(VIDEO_PLACEHOLDER_IMAGE)
        end
      end
    end

    context "Video doesn't have a YouTube source" do
      it "returns the Video Image Placeholder" do
        expect(video.image).to eq(VIDEO_PLACEHOLDER_IMAGE)
      end
    end
  end

  describe "#sync!" do
    let(:youtube) { double(:youtube, sync!: "nil") }

    before do
      allow(video).to receive(:youtube) { youtube }
      allow(video).to receive(:touch)
    end

    it "Calls YouTube Source Sync" do
      expect(youtube).to receive(:sync!)

      video.sync!
    end

    it "Calls Video Touch" do
      expect(video).to receive(:touch)

      video.sync!
    end
  end
end
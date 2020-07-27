require "rails_helper"

RSpec.describe Channel do
  let(:channel) { Channel.new }

  describe "#to_s" do
    let(:test_string) { "Test String" }

    it "returns name" do
      channel.name = test_string
      expect(channel.to_s).to eq(test_string)
    end
  end

  describe "#sync!" do
    let(:youtube) { double(:youtube, sync!: "nil") }

    before do
      allow(channel).to receive(:youtube) { youtube }
      allow(channel).to receive(:touch)
    end

    it "Calls YouTube Source Sync" do
      expect(youtube).to receive(:sync!)

      channel.sync!
    end

    it "Calls channel Touch" do
      expect(channel).to receive(:touch)

      channel.sync!
    end
  end

  describe "#normalize_friendly_id" do
    let(:channel_name) { "A Name With Spaces" }

    it "removes dashes" do
      channel.name = channel_name

      expect(channel.normalize_friendly_id(channel.name)).to eq "anamewithspaces"
    end

    it "is called on save" do
      channel.name = channel_name
      allow(channel).to receive(:save) { true }

      channel.save!
      expect(channel.slug).to eq "anamewithspaces"
    end
  end
end
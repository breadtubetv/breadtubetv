FactoryBot.define do
  factory :video_source_youtube, class: 'VideoSource::Youtube' do
    video
    url { FFaker::Youtube.url }
  end
end

FactoryBot.define do
  factory :video do
    channel
    name { FFaker::Name.unique.name }
    description { FFaker::Lorem.paragraph }
    published_at { FFaker::Time.between(7.days.ago, 5.minutes.ago) }

    after :create do |video|
      create :video_source_youtube, video: video
    end
  end
end

FactoryBot.define do
  factory :channel do
    name { FFaker::Name.unique.name }
    description { FFaker::Lorem.paragraph }
    image { "/channels/example.jpg" }
  end
end

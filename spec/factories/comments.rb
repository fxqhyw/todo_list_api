FactoryBot.define do
  factory :comment do
    body { FFaker::Lorem.sentence }
    image { nil }
    task
  end
end

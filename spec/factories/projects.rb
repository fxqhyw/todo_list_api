FactoryBot.define do
  factory :project do
    name { FFaker::Lorem.unique.word }
    user
  end
end

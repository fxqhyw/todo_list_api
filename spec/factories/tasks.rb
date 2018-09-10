FactoryBot.define do
  factory :task do
    name { FFaker::Lorem.unique.word }
    due_date { Time.zone.tomorrow }
    project
  end
end

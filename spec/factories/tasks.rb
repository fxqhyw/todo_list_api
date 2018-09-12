FactoryBot.define do
  factory :task do
    name { FFaker::Lorem.unique.word }
    deadline { nil }
    done { false }
    project
  end
end

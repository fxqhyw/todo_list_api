FactoryBot.define do
  factory :task do
    name { FFaker::Lorem.unique.word }
    deadline { nil }
    position { rand(0..10) }
    done { false }
    project
  end
end

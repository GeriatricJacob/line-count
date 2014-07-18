FactoryGirl.define do
  factory :planet do
    name { Faker::Lorem.word }
    seed { rand(100000) }
  end
end

FactoryBot.define do
  factory :client do
    name { Faker::Name.unique.name_with_middle }
  end
end

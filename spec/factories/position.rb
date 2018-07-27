FactoryBot.define do
  factory :position do
    title { Faker::Company.unique.profession }
  end
end

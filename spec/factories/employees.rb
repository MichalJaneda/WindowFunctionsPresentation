FactoryBot.define do
  factory :employee do
    name { Faker::Name.unique.name_with_middle }
    joined_on { Faker::Date.between(Date.new(2000), Date.today) }

    trait :has_leader do
      leader { create(:employee) }
    end
  end
end

FactoryBot.define do
  factory :employee, aliases: %i[seller] do
    name { Faker::Name.unique.name_with_middle }
    joined_on { Faker::Date.between(Date.new(2000), Date.today) }
    leader { nil }
  end
end

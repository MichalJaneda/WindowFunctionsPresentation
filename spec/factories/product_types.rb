FactoryBot.define do
  factory :product_type do
    name { Faker::Commerce.unique.department }
  end
end

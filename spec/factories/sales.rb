FactoryBot.define do
  factory :sale do
    client
    seller
    sold_on { Faker::Date.between(Date.new(2000), Date.today) }
    discount { Money.new(discount_cents) }

    transient do
      discount_cents { 0 }
    end

    trait :small_discount do
      discount_cents { rand(1..1_000) }
    end
  end
end

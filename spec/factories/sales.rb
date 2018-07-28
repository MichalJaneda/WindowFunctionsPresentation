FactoryBot.define do
  factory :sale do
    client
    seller
    sold_on { Faker::Date.between(Date.new(2000), Date.today) }
    discount { Money.new(discount_cents) }

    transient do
      discount_cents { 0 }
    end
  end
end

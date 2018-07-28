FactoryBot.define do
  factory :product do
    name { Faker::Commerce.unique.product_name }
    price_net { Money.new(rand(100..100_000)) }
    price_with_tax { price_net * (1 + Product::TAX_RATES.sample) }
    for_sale_since { Faker::Date.between(Date.new(2000), Date.today) }
  end
end

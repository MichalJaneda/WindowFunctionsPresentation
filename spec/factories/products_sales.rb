FactoryBot.define do
  factory :products_sales do
    sale
    product
    amount { rand(1..20) }
  end
end

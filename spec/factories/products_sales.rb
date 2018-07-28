FactoryBot.define do
  factory :products_sales, class: 'ProductsSale' do
    sale
    product
    amount { rand(1..20) }
  end
end

require 'factory_bot'

CLIENTS = 10_000
LEADERS = 30
EMPLOYEES = 120
POSITIONS = 25
PRODUCTS_TYPES = 25
PRODUCTS = 60
SALES = (CLIENTS * 4.5).to_i
PRODUCTS_PER_SALE = 1..100

clients = leaders = employees = positions = product_types = products = []

puts 'Creating clients'
CLIENTS.times { FactoryBot.create(:client) }
min_client_id = Client.first.id
max_client_id = Client.last.id

puts 'Creating users (leaders)'
leaders = FactoryBot.create_list(:employee, LEADERS)

puts 'Creating users (employees)'
employees = Array.new(EMPLOYEES) { FactoryBot.create(:employee, leader: leaders.sample) }

puts 'Creating positions'
positions = FactoryBot.create_list(:position, POSITIONS)

puts 'Creating product types'
product_types = FactoryBot.create_list(:product_type, PRODUCTS_TYPES)

puts 'Creating products'
products = Array.new(PRODUCTS) { FactoryBot.create(:product, products_types: product_types.sample(rand(1..10)) ) }

puts 'Creating paychecks'
employees.each do |employee|
  employee_positions = positions.sample(rand(1..3))
  employee_payments = Array.new(employee_positions.count) { rand(1_000..20_000) }
  payment_for_position = employee_positions.zip(employee_payments).to_h

  (employee.joined_on..Date.today).map { |d| [d.month, d.year] }.uniq.map do |month, year|
    current_position = employee_positions.sample
    FactoryBot.create(:paycheck,
                      employee: employee,
                      position: current_position,
                      pay_day: 10 + (rand(0..4).zero? ? rand(1..18) : 0),
                      payment: payment_for_position[current_position],
                      month: month, year: year)
  end
end

puts 'Creating sales'
SALES.times do
  employee = employees.sample
  sale = FactoryBot.create(:sale,
                           :small_discount,
                           client_id: rand(min_client_id..max_client_id),
                           seller: employee,
                           sold_on: rand(employee.joined_on..Date.today))

  sale_products = products.sample(rand(PRODUCTS_PER_SALE))
  sale_products.each do |product_for_sale|
    FactoryBot.create(:products_sales,
                      sale: sale,
                      product: product_for_sale)
  end
end

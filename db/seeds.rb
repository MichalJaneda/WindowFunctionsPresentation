require 'factory_bot'

CLIENTS = 1_000 * 1_000
LEADERS = 30
EMPLOYEES = 120
POSITIONS = 25
PRODUCTS_TYPES = 25
PRODUCTS = 60
SALES = (CLIENTS * 4.5).to_i
PRODUCTS_PER_SALE = 1..100

clients = leaders = employees = positions = product_types = products = []

(CLIENTS / 1_000).times { FactoryBot.create_list(:client, 1_000) }
min_client_id = Client.first.id
max_client_id = Client.last.id

leaders = FactoryBot.create_list(:employee, LEADERS)

employees = Array.new(EMPLOYEES).times { FactoryBot.create(:employee, leader: leaders.sample) }

positions = FactoryBot.create_list(:position, POSITIONS)

product_types = FactoryBot.create_list(:product_type, PRODUCTS_TYPES)

products = Array.new(PRODUCTS) { FactoryBot.create(:product, products_types: product_types.sample(rand(1..10)) ) }

threads = []

threads << Thread.new do
  Paycheck.transaction do
    paychecks = Employee.all.map do |employee|
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
    end.flatten
  end
end

threads << Thread.new do
  ApplicationRecord.transaction do
    sales = Array.new(SALES) do
      employee = employees.sample
      sale = FactoryBot.create(:sale,
                               :small_discount,
                               client: rand(min_client_id..max_client_id),
                               seller: employee,
                               sold_on: rand(employee.joined_on..Date.today))

      sale_products = products.sample(rand(PRODUCTS_PER_SALE))
      sale_products.each do |product_for_sale|
        FactoryBot.create(:products_sales,
                          sale: sale,
                          product: product_for_sale)
      end

      sale
    end
  end
end

threads.map(&:join)

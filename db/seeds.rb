require 'factory_bot'

CLIENTS = 10_000
LEADERS = 15
EMPLOYEES = 80
POSITIONS = 5
PRODUCTS_TYPES = 15
PRODUCTS = 40
SALES = (CLIENTS * 4.5).to_i
PRODUCTS_PER_SALE = 1..10

clients = leaders = employees = positions = product_types = products = []

Client.transaction do
  clients = FactoryBot.create_list(:client, CLIENTS)
end

Employee.transaction do
  leaders = FactoryBot.create_list(:employee, LEADERS)
end

Employee.transaction do
  employees = Array.new(EMPLOYEES) { FactoryBot.create(:employee, leader: leaders.sample) }
end

Position.transaction do
  positions = FactoryBot.create_list(:position, POSITIONS)
end

ProductType.transaction do
  product_types = FactoryBot.create_list(:product_type, PRODUCTS_TYPES)
end

Product.transaction do
  products = Array.new(PRODUCTS) do
    FactoryBot.create(:product,
                      products_types: product_types.sample(rand(1..10)) )
  end
end

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
                               client: clients.sample,
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

require 'factory_bot'

CLIENTS = 10_000
LEADERS = 20
EMPLOYEES = 120
POSITIONS = 15
PRODUCTS_TYPES = 40
PRODUCTS = 1_000
SALES = (CLIENTS * 3.5).to_i
PRODUCTS_SALES = 1..15

clients = FactoryBot.create_list(:client, CLIENTS)
leaders = FactoryBot.create_list(:employee, LEADERS)
employees = Array.new(EMPLOYEES) { FactoryBot.create(:employee, leader: leaders.sample) }
positions = FactoryBot.create_list(:position, POSITIONS)
product_types = FactoryBot.create_list(:product_type, PRODUCTS_TYPES)
products = Array.new(PRODUCTS) do
  FactoryBot.create(:product,
                    products_types: product_types.sample(rand(1..10)) )
end
paychecks = Employee.all.map do |employee|
  employee_positions = positions.sample(rand(1..3))
  payment = rand(1_000..20_000)
  (employee.joined_on..Date.today).map { |d| [d.month, d.year] }.uniq.map do |month, year|
    FactoryBot.create(:paycheck,
                      employee: employee,
                      position: employee_positions.sample,
                      pay_day: 10 + (rand(0..4).zero? ? rand(1..18) : 0),
                      payment: payment,
                      month: month, year: year)
  end
end.flatten
sales = Array.new(SALES) do
  employee = employees.sample
  sale = FactoryBot.create(:sale,
                           :small_discount,
                           client: clients.sample,
                           seller: employee,
                           sold_on: rand(employee.joined_on..Date.today) )

  sale_products = products.sample(rand(PRODUCTS_SALES))
  Array.new(sale_products) do
    FactoryBot.create(:products_sales,
                      sale: sale,
                      product: products.sample)
  end

  sale
end

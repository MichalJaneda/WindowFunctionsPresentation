FactoryBot.define do
  factory :paycheck do
    employee
    position

    month { rand(1..12) }
    year { rand(2000..Time.current.year) }
    paid_on { Date.new(year, month, pay_day) }
    payment { Money.new(rand(800..20_000)) }
    bonus { Money.new(rand(0..6).zero? ? rand(100..2_000) : 0) }

    transient do
      pay_day { 10 }
    end
  end
end

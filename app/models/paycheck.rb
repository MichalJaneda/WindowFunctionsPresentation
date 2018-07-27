class Paycheck < ApplicationRecord
  validates :paid_on, presence: true
  validates :year,
            presence: true,
            numericality:
              {
                greater_than_or_equal_to: 1970,
                only_integer: true
              }
  validates :month,
            presence: true,
            numericality:
              {
                greater_than_or_equal_to: 1,
                less_than_or_equal_to: 12,
                only_integer: true
              }
  validates :employee_id,
            uniqueness: { scope: %i[month year] }

  monetize :payment_cents, numericality: { greater_than: 0 }
  monetize :bonus_cents, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :employee
  belongs_to :position
end

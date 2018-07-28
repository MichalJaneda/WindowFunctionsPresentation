class ProductsSales < ApplicationRecord
  validates :amount,
            presence: true,
            numericality: { greater_than: 0 }
  validates :sale_id,
            uniqueness: { scope: :product_id }

  belongs_to :product
  belongs_to :sale
end

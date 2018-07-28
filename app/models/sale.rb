class Sale < ApplicationRecord
  validates :sold_on, presence: true

  monetize :discount_cents, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :client
  belongs_to :seller, class_name: 'Employee'

  has_many :products_sales
  has_many :products, through: :products_sales
end

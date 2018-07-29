class Product < ApplicationRecord
  TAX_RATES = [0, 5, 8, 23].freeze

  validates :for_sale_since, presence: true
  validates :name, presence: true

  monetize :price_net_cents, numericality: { greater_than: 0 }
  monetize :cost_of_production_cents, numericality: { greater_than: 0 }
  monetize :price_with_tax_cents, numericality: { greater_than: 0 }

  has_many :products_sales
  has_many :sales, through: :products_sales
  has_and_belongs_to_many :types, class_name: 'ProductType'.freeze
end

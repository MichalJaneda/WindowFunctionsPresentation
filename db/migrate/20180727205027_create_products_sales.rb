class CreateProductsSales < ActiveRecord::Migration[5.1]
  def change
    create_table :products_sales do |t|
      t.belongs_to :product, foreign_key: true
      t.belongs_to :sale, foreign_key: true

      t.integer :amount

      t.index %i[product_id sale_id], unique: true
    end
  end
end

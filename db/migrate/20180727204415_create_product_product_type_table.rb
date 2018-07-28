class CreateProductProductTypeTable < ActiveRecord::Migration[5.1]
  def change
    create_table :product_types_products do |t|
      t.belongs_to :product, foreign_key: true
      t.belongs_to :product_type, foreign_key: true

      t.index %i[product_id product_type_id], unique: true
    end
  end
end

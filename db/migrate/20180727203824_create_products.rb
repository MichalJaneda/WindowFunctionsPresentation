class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name, unique: true

      t.monetize :price_net
      t.monetize :price_with_tax
      t.monetize :cost_of_production

      t.date :for_sale_since
    end
  end
end

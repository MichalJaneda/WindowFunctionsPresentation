class CreateSales < ActiveRecord::Migration[5.1]
  def change
    create_table :sales do |t|
      t.belongs_to :seller, index: true, foreign_key: { to_table: :employees }
      t.belongs_to :client, index: true, foreign_key: true
      t.date :sold_on, index: true
      t.monetize :discount, default: 0
    end
  end
end

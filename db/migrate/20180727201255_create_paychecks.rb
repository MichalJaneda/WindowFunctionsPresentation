class CreatePaychecks < ActiveRecord::Migration[5.1]
  def change
    create_table :paychecks do |t|
      t.belongs_to :employee, foreign_key: true

      t.integer :year, limit: 2
      t.integer :month, limit: 1
      t.date :paid_on

      t.monetize :payment
      t.monetize :bonus, default: 0

      t.index %i[year month employee_id], unique: true
    end
  end
end

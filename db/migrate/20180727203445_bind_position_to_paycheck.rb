class BindPositionToPaycheck < ActiveRecord::Migration[5.1]
  def change
    add_reference :paychecks, :positions, index: true, null: true, foreign_key: true
  end
end

class BindPositionToPaycheck < ActiveRecord::Migration[5.1]
  def change
    add_reference :paychecks, :position, index: true, null: true, foreign_key: true
  end
end

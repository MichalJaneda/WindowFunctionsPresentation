class AddLeaderToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :employees, :leader, index: true, null: true, foreign_key: { to_table: :employees }
  end
end

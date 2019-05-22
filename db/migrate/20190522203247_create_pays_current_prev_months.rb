class CreatePaysCurrentPrevMonths < ActiveRecord::Migration[5.1]
  def change
    create_view :pays_current_prev_months
  end
end

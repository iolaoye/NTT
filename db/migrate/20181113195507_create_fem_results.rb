class CreateFemResults < ActiveRecord::Migration[5.2]
  def change
    create_table :fem_results do |t|
      t.float :total_revenue
      t.float :total_cost
      t.float :net_return
      t.float :net_cash_flow

      t.timestamps null: false
    end
  end
end

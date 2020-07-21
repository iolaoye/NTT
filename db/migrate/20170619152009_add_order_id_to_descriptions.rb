class AddOrderIdToDescriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :descriptions, :order_id, :integer
  end
end

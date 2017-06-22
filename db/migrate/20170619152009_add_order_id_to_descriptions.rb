class AddOrderIdToDescriptions < ActiveRecord::Migration
  def change
    add_column :descriptions, :order_id, :integer
  end
end

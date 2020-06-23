class RenameColumnOrderToPositionResult < ActiveRecord::Migration[5.2]
  def change
    rename_column :results, :order, :position
  end
end

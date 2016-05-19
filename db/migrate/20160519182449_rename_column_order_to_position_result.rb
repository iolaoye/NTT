class RenameColumnOrderToPositionResult < ActiveRecord::Migration
  def change
    rename_column :results, :order, :position
  end
end

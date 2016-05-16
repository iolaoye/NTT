class AddColumnApexOperationToSoilOperation < ActiveRecord::Migration
  def change
    add_column :soil_operations, :apex_operation, :integer
  end
end

class AddColumnApexOperationToSoilOperation < ActiveRecord::Migration[5.2]
  def change
    add_column :soil_operations, :apex_operation, :integer
  end
end

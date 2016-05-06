class AddOperationIdColumnToOperation < ActiveRecord::Migration
  def change
    add_column :soil_operations, :scenario_id, :integer
    add_column :soil_operations, :soil_id, :integer
  end
end

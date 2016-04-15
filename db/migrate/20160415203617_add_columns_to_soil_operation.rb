class AddColumnsToSoilOperation < ActiveRecord::Migration
  def change
    add_column :soil_operations, :year, :integer
    add_column :soil_operations, :month, :integer
    add_column :soil_operations, :day, :integer
    add_column :soil_operations, :operation_id, :integer
    add_column :soil_operations, :tractor_id, :integer
    add_column :soil_operations, :crop_id, :integer
    add_column :soil_operations, :type_id, :integer
    add_column :soil_operations, :opv1, :float
    add_column :soil_operations, :opv2, :float
    add_column :soil_operations, :opv3, :float
    add_column :soil_operations, :opv4, :float
    add_column :soil_operations, :opv5, :float
    add_column :soil_operations, :opv6, :float
    add_column :soil_operations, :opv7, :float
  end
end

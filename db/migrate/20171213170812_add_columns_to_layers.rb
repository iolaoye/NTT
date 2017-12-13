class AddColumnsToLayers < ActiveRecord::Migration
  def change
    add_column :layers, :soil_test_id, :integer
    add_column :layers, :soil_p_initial, :float
    add_column :layers, :soil_aluminum, :float
  end
end

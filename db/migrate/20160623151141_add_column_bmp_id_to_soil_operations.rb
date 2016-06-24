class AddColumnBmpIdToSoilOperations < ActiveRecord::Migration
  def change
    add_column :soil_operations, :bmp_id, :integer
  end
end

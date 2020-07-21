class AddColumnBmpIdToSoilOperations < ActiveRecord::Migration[5.2]
  def change
    add_column :soil_operations, :bmp_id, :integer
  end
end

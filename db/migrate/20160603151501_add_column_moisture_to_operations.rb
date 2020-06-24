class AddColumnMoistureToOperations < ActiveRecord::Migration[5.2]
  def change
    add_column :operations, :moisture, :float
  end
end

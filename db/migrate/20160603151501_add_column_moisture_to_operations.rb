class AddColumnMoistureToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :moisture, :float
  end
end

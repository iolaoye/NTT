class AddColumnRotationToOperations < ActiveRecord::Migration[5.2]
  def change
    add_column :operations, :rotation, :integer
  end
end

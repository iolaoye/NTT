class AddColumnRotationToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :rotation, :integer
  end
end

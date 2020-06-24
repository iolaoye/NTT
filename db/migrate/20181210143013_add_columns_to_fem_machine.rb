class AddColumnsToFemMachine < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_machines, :codes, :integer
    add_column :fem_machines, :ownership, :integer
  end
end

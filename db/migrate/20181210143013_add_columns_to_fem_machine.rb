class AddColumnsToFemMachine < ActiveRecord::Migration
  def change
    add_column :fem_machines, :codes, :integer
    add_column :fem_machines, :ownership, :integer
  end
end

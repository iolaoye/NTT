class AddUnitColumnToFemMachine < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_machines, :unit, :string
  end
end

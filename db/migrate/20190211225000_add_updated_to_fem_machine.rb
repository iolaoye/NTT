class AddUpdatedToFemMachine < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_machines, :updated, :boolean
  end
end

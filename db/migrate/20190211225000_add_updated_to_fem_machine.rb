class AddUpdatedToFemMachine < ActiveRecord::Migration
  def change
    add_column :fem_machines, :updated, :boolean
  end
end

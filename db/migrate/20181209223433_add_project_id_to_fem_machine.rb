class AddProjectIdToFemMachine < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_machines, :project_id, :integer
  end
end

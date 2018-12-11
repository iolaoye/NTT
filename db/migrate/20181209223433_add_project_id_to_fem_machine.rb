class AddProjectIdToFemMachine < ActiveRecord::Migration
  def change
    add_column :fem_machines, :project_id, :integer
  end
end

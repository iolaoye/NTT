class AddProjectIdToFemGeneral < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_generals, :project_id, :integer
  end
end

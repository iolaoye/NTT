class AddProjectIdToFemGeneral < ActiveRecord::Migration
  def change
    add_column :fem_generals, :project_id, :integer
  end
end

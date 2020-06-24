class AddProjectIdToFemFacility < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_facilities, :project_id, :integer
  end
end

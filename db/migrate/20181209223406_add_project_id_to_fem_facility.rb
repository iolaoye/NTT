class AddProjectIdToFemFacility < ActiveRecord::Migration
  def change
    add_column :fem_facilities, :project_id, :integer
  end
end

class AddProjectIdToFemFeed < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_feeds, :project_id, :integer
  end
end

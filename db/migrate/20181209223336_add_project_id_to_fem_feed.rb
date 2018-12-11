class AddProjectIdToFemFeed < ActiveRecord::Migration
  def change
    add_column :fem_feeds, :project_id, :integer
  end
end

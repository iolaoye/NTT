class AddColumnToWatershed < ActiveRecord::Migration
  def change
    add_column :watersheds, :location_id, :integer
  end
end

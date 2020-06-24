class AddColumnToWatershed < ActiveRecord::Migration[5.2]
  def change
    add_column :watersheds, :location_id, :integer
  end
end

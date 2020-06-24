class RemoveColumnFromWatershed < ActiveRecord::Migration[5.2]
  def up
    remove_column :watersheds, :field_id
    remove_column :watersheds, :scenario_id
  end
end

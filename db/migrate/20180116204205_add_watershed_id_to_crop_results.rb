class AddWatershedIdToCropResults < ActiveRecord::Migration
  def change
    add_column :crop_results, :watershed_id, :integer
  end
end

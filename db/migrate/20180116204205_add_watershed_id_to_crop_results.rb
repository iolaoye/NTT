class AddWatershedIdToCropResults < ActiveRecord::Migration[5.2]
  def change
    add_column :crop_results, :watershed_id, :integer
  end
end

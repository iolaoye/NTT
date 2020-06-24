class RenameColumnCropIdToApexCropToTableSoilOperation < ActiveRecord::Migration[5.2]
  def change
	rename_column :soil_operations, :crop_id, :apex_crop
  end

end

class RenameColumnCropIdToApexCropToTableSoilOperation < ActiveRecord::Migration
  def change
	rename_column :soil_operations, :crop_id, :apex_crop
  end

end

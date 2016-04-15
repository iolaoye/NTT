class RenameColumnFromFertilizer < ActiveRecord::Migration
  def change
	rename_column :fertilizers, :type_id, :fertilizer_type_id
  end
end

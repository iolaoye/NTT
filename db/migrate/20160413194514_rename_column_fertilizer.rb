class RenameColumnFertilizer < ActiveRecord::Migration
  def change
	rename_column :fertilizers, :type1, :type_id
  end
end

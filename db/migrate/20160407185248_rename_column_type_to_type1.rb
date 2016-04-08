class RenameColumnTypeToType1 < ActiveRecord::Migration
  def change
	rename_column :crops, :type, :type1
  end
end

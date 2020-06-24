class RenameColumnTypeToType1 < ActiveRecord::Migration[5.2]
  def change
	rename_column :crops, :type, :type1
  end
end

class RenameColumnTableIssueClassIdToTypeId < ActiveRecord::Migration[5.2]
  def change
     rename_column :issues, :class_id, :type_id
     rename_column :issues, :descritpion, :description
  end
end

class RenameColumnTypeToSubareaTypeInTableSubarea < ActiveRecord::Migration[5.2]
  def change
     rename_column :subareas, :type, :subarea_type
  end
end

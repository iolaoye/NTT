class RenameColumnTypeToSubareaTypeInTableSubarea < ActiveRecord::Migration
  def change
     rename_column :subareas, :type, :subarea_type
  end
end

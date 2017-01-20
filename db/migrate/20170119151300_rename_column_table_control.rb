class RenameColumnTableControl < ActiveRecord::Migration
  def change
     rename_column :apex_controls, :control_id, :control_description_id
  end
end

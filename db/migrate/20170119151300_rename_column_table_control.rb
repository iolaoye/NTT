class RenameColumnTableControl < ActiveRecord::Migration[5.2]
  def change
     rename_column :apex_controls, :control_id, :control_description_id
  end
end

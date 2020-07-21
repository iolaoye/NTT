class RenameColumn < ActiveRecord::Migration[5.2]
  def change
     rename_column :crop_schedules, :class, :class_id
  end
end

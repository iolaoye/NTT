class RenameColumn < ActiveRecord::Migration
  def change
     rename_column :crop_schedules, :class, :class_id
  end
end

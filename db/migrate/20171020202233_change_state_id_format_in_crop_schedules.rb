class ChangeStateIdFormatInCropSchedules < ActiveRecord::Migration[5.2]
  def change
  	change_column :crop_schedules, :state_id, :string
  end
end

class ChangeStateIdFormatInCropSchedules < ActiveRecord::Migration
  def change
  	change_column :crop_schedules, :state_id, :string
  end
end

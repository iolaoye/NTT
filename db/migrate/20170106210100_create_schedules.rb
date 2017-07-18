class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :schedule_id
      t.integer :event_order
      t.integer :month
      t.integer :day
      t.integer :year
      t.integer :activity_id
      t.integer :apex_operation
      t.integer :apex_crop
      t.integer :apex_fertilizer
      t.float :apex_opv1
      t.float :apex_opv2
      t.integer :crop_schedule_id

      t.timestamps
    end
  end
end

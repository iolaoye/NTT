class CreateCropSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :crop_schedules do |t|
      t.integer :crop_schedule_id
      t.string :name
      t.integer :state_id
      t.integer :class
      t.boolean :status

      t.timestamps
    end
  end
end

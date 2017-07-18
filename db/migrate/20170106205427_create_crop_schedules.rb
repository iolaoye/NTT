class CreateCropSchedules < ActiveRecord::Migration
  def change
    create_table :crop_schedules do |t|
      t.integer :self_id
      t.string :name
      t.integer :state_id
      t.integer :class
      t.boolean :status

      t.timestamps
    end
  end
end

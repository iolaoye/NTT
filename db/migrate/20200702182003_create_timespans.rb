class CreateTimespans < ActiveRecord::Migration[5.2]
  def change
    create_table :timespans do |t|
      t.integer :bmp_id
      t.integer :crop_id
      t.integer :start_month
      t.integer :start_day
      t.integer :end_month
      t.integer :end_day

      t.timestamps
    end
  end
end

class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :state_id
      t.integer :county_id
      t.string :status
      t.integer :project_id

      t.timestamps
    end
  end
end

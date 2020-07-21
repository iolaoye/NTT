class CreateLocations < ActiveRecord::Migration[5.2]
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

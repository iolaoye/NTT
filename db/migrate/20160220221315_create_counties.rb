class CreateCounties < ActiveRecord::Migration
  def change
    create_table :counties do |t|
      t.string :county_name
      t.string :county_code
      t.integer :status
      t.float :latitude
      t.float :longitude
      t.integer :state_id

      t.timestamps
    end
  end
end

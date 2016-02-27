class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
	  t.integer :county_id
      t.string :station_name
      t.string :station_code
      t.string :station_type
      t.boolean :station_status
	  t.integer :wind_code
	  t.integer :wp1_code
	  t.string :wind_name
	  t.string :wp1_name
	  t.integer :initial_year
	  t.integer :final_year

      t.timestamps
    end
  end
end

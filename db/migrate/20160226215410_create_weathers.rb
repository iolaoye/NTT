class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.integer :field_id
      t.integer :station_id
      t.string :station_way
      t.integer :simulation_initial_year
      t.integer :simulation_final_year
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end

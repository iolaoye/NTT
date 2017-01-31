class CreateGrazingParameters < ActiveRecord::Migration
  def change
    create_table :grazing_parameters do |t|
	  t.integer :scenario_id
      t.integer :code
      t.integer :starting_julian_day
      t.integer :ending_julian_day
      t.integer :dmi_code
      t.float :dmi_cows
      t.float :dmi_bulls
      t.float :dmi_heifers
      t.float :dmi_calves
      t.float :green_water_footprint

      t.timestamps
    end
  end
end

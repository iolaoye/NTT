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
      t.float :dmi_rheifers
      t.float :green_water_footprint
      t.float :for_dmi_cows
      t.float :for_dmi_bulls
      t.float :for_dmi_heifers
      t.float :for_dmi_calves
      t.float :for_dmi_rheifers

      t.timestamps
    end
  end
end

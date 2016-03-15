class CreateBmps < ActiveRecord::Migration
  def change
    create_table :bmps do |t|
	  t.integer :bmp_id
      t.integer :scenario_id
	  t.integer :crop_id
	  t.integer :irrigation_id
	  t.float :water_stress_factor
	  t.float :irrigation_efficiency
	  t.float :maximum_single_application
	  t.float :safety_factor
	  t.float :depth
	  t.float :area
	  t.integer :number_of_animals
	  t.integer :days
	  t.integer :hours
	  t.integer :animal_id
	  t.float :dry_manure 
	  t.float :no3_n
	  t.float :po4_p
	  t.float :org_n
	  t.float :org_p
	  t.float :width
	  t.float :grass_field_portion
	  t.float :buffer_slope_upland
	  t.float :crop_width
	  t.float :slope_reduction
	  t.integer :sides

      t.timestamps
    end
  end
end

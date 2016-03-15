class CreateCrops < ActiveRecord::Migration
  def change
    create_table :crops do |t|
      t.integer :number
      t.integer :dndc
      t.string :code
      t.string :name
      t.float :plant_population_mt
      t.float :plant_population_ac
      t.float :plant_population_ft
      t.float :heat_units
      t.integer :lu_number
      t.integer :soil_group_a
      t.integer :soil_group_b
      t.integer :soil_group_c
      t.integer :soil_group_d
      t.string :type
      t.string :yield_unit
      t.float :bushel_weight
      t.float :conversion_factor
      t.float :dry_matter
      t.integer :harvest_code
      t.integer :planting_code
      t.string :state_id
      t.float :itil
      t.float :to1
      t.float :tb
      t.integer :dd
      t.integer :dyam
      t.string :spanish_name

      t.timestamps
    end
  end
end

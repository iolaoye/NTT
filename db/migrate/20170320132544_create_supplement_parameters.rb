class CreateSupplementParameters < ActiveRecord::Migration
  def change
    create_table :supplement_parameters do |t|
      t.integer :scenario_id
      t.integer :code
      t.integer :dmi_code
      t.float :dmi_cows
      t.float :dmi_bulls
      t.float :dmi_heifers
      t.float :dmi_calves
      t.integer :green_water_footprint

      t.timestamps
    end
  end
end

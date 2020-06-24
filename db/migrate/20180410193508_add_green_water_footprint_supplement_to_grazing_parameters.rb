class AddGreenWaterFootprintSupplementToGrazingParameters < ActiveRecord::Migration[5.2]
  def change
    add_column :grazing_parameters, :green_water_footprint_supplement, :float
  end
end

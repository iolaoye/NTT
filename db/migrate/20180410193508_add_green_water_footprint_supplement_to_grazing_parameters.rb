class AddGreenWaterFootprintSupplementToGrazingParameters < ActiveRecord::Migration
  def change
    add_column :grazing_parameters, :green_water_footprint_supplement, :float
  end
end

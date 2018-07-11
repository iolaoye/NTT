class AddColumnToSupplementParameters < ActiveRecord::Migration
  def change
    add_column :supplement_parameters, :dmi_rheifers, :float
    add_column :supplement_parameters, :starting_julian_day, :integer
    add_column :supplement_parameters, :ending_julian_day, :integer
    add_column :supplement_parameters, :for_dmi_cows, :float
    add_column :supplement_parameters, :for_dmi_bulls, :float
    add_column :supplement_parameters, :for_dmi_calves, :float
    add_column :supplement_parameters, :for_dmi_heifers, :float
    add_column :supplement_parameters, :for_dmi_rheifers, :float
    add_column :supplement_parameters, :green_water_footprint_supplement, :float
    add_column :supplement_parameters, :for_button, :integer
    add_column :supplement_parameters, :supplement_button, :integer
  end
end

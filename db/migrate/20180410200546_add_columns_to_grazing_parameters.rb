class AddColumnsToGrazingParameters < ActiveRecord::Migration
  def change
    add_column :grazing_parameters, :for_dmi_cows, :float
    add_column :grazing_parameters, :for_dmi_bulls, :float
    add_column :grazing_parameters, :for_dmi_heifers, :float
    add_column :grazing_parameters, :for_dmi_calves, :float
    add_column :grazing_parameters, :for_dmi_rheifers, :float
    add_column :grazing_parameters, :dmi_rheifers, :float
  end
end

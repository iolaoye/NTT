class AddRunParmToAplcatParameters < ActiveRecord::Migration[5.2]
  def change
    add_column :aplcat_parameters, :running_drinking_water, :string
    add_column :aplcat_parameters, :running_complete_stocker, :string
    add_column :aplcat_parameters, :running_ghg, :string
    add_column :aplcat_parameters, :running_transportation, :string
  end
end

class AddForageQuantityInputToAplcatParameters < ActiveRecord::Migration
  def change
    add_column :aplcat_parameters, :cpl_lowest, :float
    add_column :aplcat_parameters, :cpl_highest, :float
    add_column :aplcat_parameters, :tdn_lowest, :float
    add_column :aplcat_parameters, :tdn_highest, :float
    add_column :aplcat_parameters, :ndf_lowest, :float
    add_column :aplcat_parameters, :ndf_highest, :float
    add_column :aplcat_parameters, :adf_lowest, :float
    add_column :aplcat_parameters, :adf_highest, :float
    add_column :aplcat_parameters, :fir_lowest, :float
    add_column :aplcat_parameters, :fir_highest, :float
  end
end

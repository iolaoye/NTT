class AddRadioButtonsToAplcatParameters < ActiveRecord::Migration
  def change
    add_column :aplcat_parameters, :mm_type_but, :integer
    add_column :aplcat_parameters, :nit, :integer
    add_column :aplcat_parameters, :fqd, :integer
    add_column :aplcat_parameters, :uovfi, :integer
    add_column :aplcat_parameters, :srwc, :integer
    add_column :aplcat_parameters, :byos, :integer
    add_column :aplcat_parameters, :eyos, :integer
  end
end

class AddCowsToAplcatResults < ActiveRecord::Migration
  def change
    add_column :aplcat_results, :cow_aws, :float
    add_column :aplcat_results, :cow_dmi, :float
    add_column :aplcat_results, :cow_gei, :float
    add_column :aplcat_results, :cow_wi, :float
    add_column :aplcat_results, :cow_sme, :float
    add_column :aplcat_results, :cow_ni, :float
    add_column :aplcat_results, :cow_tne, :float
    add_column :aplcat_results, :cow_tnr, :float
    add_column :aplcat_results, :cow_fne, :float
    add_column :aplcat_results, :cow_une, :float
    add_column :aplcat_results, :cow_eme, :float
    add_column :aplcat_results, :cow_mme, :float
  end
end

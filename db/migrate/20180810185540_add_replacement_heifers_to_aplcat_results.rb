class AddReplacementHeifersToAplcatResults < ActiveRecord::Migration
  def change
    add_column :aplcat_results, :rh_aws, :float
    add_column :aplcat_results, :rh_dmi, :float
    add_column :aplcat_results, :rh_gei, :float
    add_column :aplcat_results, :rh_wi, :float
    add_column :aplcat_results, :rh_sme, :float
    add_column :aplcat_results, :rh_ni, :float
    add_column :aplcat_results, :rh_tne, :float
    add_column :aplcat_results, :rh_tnr, :float
    add_column :aplcat_results, :rh_fne, :float
    add_column :aplcat_results, :rh_une, :float
    add_column :aplcat_results, :rh_eme, :float
    add_column :aplcat_results, :rh_mme, :float
  end
end

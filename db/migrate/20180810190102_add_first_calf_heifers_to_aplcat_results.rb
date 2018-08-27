class AddFirstCalfHeifersToAplcatResults < ActiveRecord::Migration
  def change
    add_column :aplcat_results, :fch_aws, :float
    add_column :aplcat_results, :fch_dmi, :float
    add_column :aplcat_results, :fch_gei, :float
    add_column :aplcat_results, :fch_wi, :float
    add_column :aplcat_results, :fch_sme, :float
    add_column :aplcat_results, :fch_ni, :float
    add_column :aplcat_results, :fch_tne, :float
    add_column :aplcat_results, :fch_tnr, :float
    add_column :aplcat_results, :fch_fne, :float
    add_column :aplcat_results, :fch_une, :float
    add_column :aplcat_results, :fch_eme, :float
    add_column :aplcat_results, :fch_mme, :float
  end
end

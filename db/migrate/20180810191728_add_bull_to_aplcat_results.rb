class AddBullToAplcatResults < ActiveRecord::Migration
  def change
    add_column :aplcat_results, :bull_aws, :float
    add_column :aplcat_results, :bull_dmi, :float
    add_column :aplcat_results, :bull_gei, :float
    add_column :aplcat_results, :bull_wi, :float
    add_column :aplcat_results, :bull_sme, :float
    add_column :aplcat_results, :bull_ni, :float
    add_column :aplcat_results, :bull_tne, :float
    add_column :aplcat_results, :bull_tnr, :float
    add_column :aplcat_results, :bull_fne, :float
    add_column :aplcat_results, :bull_une, :float
    add_column :aplcat_results, :bull_eme, :float
    add_column :aplcat_results, :bull_mme, :float
  end
end

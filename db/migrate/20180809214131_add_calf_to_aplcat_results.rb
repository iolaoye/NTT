class AddCalfToAplcatResults < ActiveRecord::Migration
  def change
    add_column :aplcat_results, :calf_aws, :float
    add_column :aplcat_results, :calf_dmi, :float
    add_column :aplcat_results, :calf_gei, :float
    add_column :aplcat_results, :calf_wi, :float
    add_column :aplcat_results, :calf_sme, :float
    add_column :aplcat_results, :calf_ni, :float
    add_column :aplcat_results, :calf_tne, :float
    add_column :aplcat_results, :calf_tnr, :float
    add_column :aplcat_results, :calf_fne, :float
    add_column :aplcat_results, :calf_une, :float
    add_column :aplcat_results, :calf_eme, :float
    add_column :aplcat_results, :calf_mme, :float
  end
end

class AddWifColumnToAplcatresults < ActiveRecord::Migration[5.2]
  # Add column 'Water intake with feed' to Aplcat Results table
  def change
    add_column :aplcat_results, :calf_wif, :float
    add_column :aplcat_results, :rh_wif, :float
    add_column :aplcat_results, :fch_wif, :float
    add_column :aplcat_results, :cow_wif, :float
    add_column :aplcat_results, :bull_wif, :float
  end
end

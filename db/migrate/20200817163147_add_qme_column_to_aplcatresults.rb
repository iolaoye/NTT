class AddQmeColumnToAplcatresults < ActiveRecord::Migration[5.2]
  # Add column 'Quantity of manure excreted' to Aplcat Results table
  def change
    add_column :aplcat_results, :calf_qme, :float
    add_column :aplcat_results, :rh_qme, :float
    add_column :aplcat_results, :fch_qme, :float
    add_column :aplcat_results, :cow_qme, :float
    add_column :aplcat_results, :bull_qme, :float
  end
end

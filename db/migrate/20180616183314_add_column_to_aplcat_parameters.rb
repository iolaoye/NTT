class AddColumnsToAplcatParameters < ActiveRecord::Migration
  def change
    add_column :aplcat_parameters, :abwrh, :float
    add_column :aplcat_parameters, :nocrh, :integer
    add_column :aplcat_parameters, :abc, :integer
    add_column :aplcat_parameters, :forage_id, :integer
  end
end

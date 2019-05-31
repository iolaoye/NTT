class AddYearsToAplcatParameters < ActiveRecord::Migration
  def change
    add_column :aplcat_parameters, :byos, :integer
    add_column :aplcat_parameters, :eyos, :integer
  end
end

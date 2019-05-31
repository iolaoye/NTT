class AddYearsToAplcatParameters < ActiveRecord::Migration
  def change
  	if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :mm_type_but)) 
	    add_column :aplcat_parameters, :byos, :integer
	end
	if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :mm_type_but)) 
	    add_column :aplcat_parameters, :eyos, :integer
	end
  end
end

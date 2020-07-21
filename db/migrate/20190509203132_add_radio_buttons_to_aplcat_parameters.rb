class AddRadioButtonsToAplcatParameters < ActiveRecord::Migration[5.2]
  def change
  	if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :mm_type_but)) 
    	add_column :aplcat_parameters, :mm_type_but, :integer
	end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :mm_type_but)) 
    	add_column :aplcat_parameters, :nit, :integer
	end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :mm_type_but)) 
    	add_column :aplcat_parameters, :fqd, :integer
	end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :mm_type_but)) 
    	add_column :aplcat_parameters, :uovfi, :integer
	end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :mm_type_but)) 
	    add_column :aplcat_parameters, :srwc, :integer
	end
	if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :mm_type_but)) 
	    add_column :aplcat_parameters, :byos, :integer
	end
	if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :mm_type_but)) 
	    add_column :aplcat_parameters, :eyos, :integer
	end
  end
end

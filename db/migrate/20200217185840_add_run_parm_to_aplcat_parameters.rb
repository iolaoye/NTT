class AddRunParmToAplcatParameters < ActiveRecord::Migration[5.2]
  def change
  	if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :running_drinking_water)) 
    	add_column :aplcat_parameters, :running_drinking_water, :string
	end
  	if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :running_complete_stocker)) 
    	add_column :aplcat_parameters, :running_complete_stocker, :string
	end
  	if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :running_ghg)) 
    	add_column :aplcat_parameters, :running_ghg, :string
	end
  	if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :running_transportation)) 
    	add_column :aplcat_parameters, :running_transportation, :string
	end
  end
end

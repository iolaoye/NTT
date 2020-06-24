class AddColumnsToGrazingParameters < ActiveRecord::Migration[5.2]
  def change
  	if !ActiveRecord::Base.connection.column_exists?(:grazing_parameters, :for_dmi_cows)
    	add_column :grazing_parameters, :for_dmi_cows, :float
    end
  	if !ActiveRecord::Base.connection.column_exists?(:grazing_parameters, :for_dmi_cows)
    	add_column :grazing_parameters, :for_dmi_bulls, :float
    end
    if !ActiveRecord::Base.connection.column_exists?(:grazing_parameters, :for_dmi_cows)
    	add_column :grazing_parameters, :for_dmi_heifers, :float
    end  	
    if !ActiveRecord::Base.connection.column_exists?(:grazing_parameters, :for_dmi_cows)
    	add_column :grazing_parameters, :for_dmi_calves, :float
    end  	
    if !ActiveRecord::Base.connection.column_exists?(:grazing_parameters, :for_dmi_cows)
    	add_column :grazing_parameters, :for_dmi_rheifers, :float
    end  	
    if !ActiveRecord::Base.connection.column_exists?(:grazing_parameters, :for_dmi_cows)
    	add_column :grazing_parameters, :dmi_rheifers, :float
    end    
  end
end

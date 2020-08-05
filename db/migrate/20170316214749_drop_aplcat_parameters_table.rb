class DropAplcatParametersTable < ActiveRecord::Migration[5.2]
  if ActiveRecord::Base.connection.data_source_exists? 'aplcat_parameters'
	  def up 	
		drop_table :aplcat_parameters
	  end
  end
end

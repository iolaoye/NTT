class DropAplcatParametersTable < ActiveRecord::Migration[5.2]
  def up
  	if ActiveRecord::Base.connection.data_source_exists? 'aplcat_parameters'
		drop_table :aplcat_parameters
	end
  end
end

class AddColumnToAplcatParameter < ActiveRecord::Migration[5.2]
  def change
  	if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :forage))
	    add_column :aplcat_parameters, :forage, :boolean
	end
  end
end

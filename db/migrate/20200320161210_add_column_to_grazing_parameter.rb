class AddColumnToGrazingParameter < ActiveRecord::Migration[5.2]
  def change
  	if !(ActiveRecord::Base.connection.column_exists?(:grazing_parameters, :forage))
    	add_column :grazing_parameters, :forage, :boolean
    end
  end
end

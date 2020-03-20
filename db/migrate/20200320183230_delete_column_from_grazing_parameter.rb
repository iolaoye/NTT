class DeleteColumnFromGrazingParameter < ActiveRecord::Migration[5.2]
  def change
 	if (ActiveRecord::Base.connection.column_exists?(:grazing_parameters, :forage))
		remove_column :grazing_parameters, :forage
	end
  end
end

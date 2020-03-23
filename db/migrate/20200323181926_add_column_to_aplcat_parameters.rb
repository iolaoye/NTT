class AddColumnToAplcatParameters < ActiveRecord::Migration[5.2]
  def change
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :fuel_id))
    	add_column :aplcat_parameters, :fuel_id, :string
    end
  end
end

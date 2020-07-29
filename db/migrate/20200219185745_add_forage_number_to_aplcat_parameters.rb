class AddForageNumberToAplcatParameters < ActiveRecord::Migration[5.2]
  def change
  	if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :number_of_forage)) 
	    add_column :aplcat_parameters, :number_of_forage, :string
	end
  end
end

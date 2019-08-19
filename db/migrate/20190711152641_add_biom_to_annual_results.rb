class AddBiomToAnnualResults < ActiveRecord::Migration
  def change
   	if !(ActiveRecord::Base.connection.column_exists?(:annual_results, :biom)) 
    	add_column :annual_results, :biom, :float
	end
  end
end

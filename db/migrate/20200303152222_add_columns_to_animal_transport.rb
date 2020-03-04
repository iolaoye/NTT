class AddColumnsToAnimalTransport < ActiveRecord::Migration[5.2]
	def change
	  	if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :animal_transport_id))
	    	add_column :animal_transports, :freq_trip, :integer
	    end
	  	if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :weight))
	    	add_column :animal_transports, :cattle_pro, :real
	    end
	    if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :animals))
	    	add_column :animal_transports, :purpose, :integer
	    end  
	end
end

class AddColumnsToAnimalTransport < ActiveRecord::Migration[5.2]
  def change
  	if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :freq_trip))
    	add_column :animal_transports, :freq_trip, :integer
    end
  	if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :cattle_pro))
    	add_column :animal_transports, :cattle_pro, :boolean
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :purpose))
    	add_column :animal_transports, :purpose, :integer
    end  	
    if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :trans))
    	add_column :animal_transports, :trans, :integer
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :categories_trans))
    	add_column :animal_transports, :categories_trans, :integer
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :categories_slaug))
    	add_column :animal_transports, :categories_slaug, :integer
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :animal_category_id))
    	add_column :animal_transports, :avg_marweight, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :mortality_rate))
    	add_column :animal_transports, :mortality_rate, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :distance))
    	add_column :animal_transports, :distance, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :trailer_id))
    	add_column :animal_transports, :trailer_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :truck_id))
    	add_column :animal_transports, :truck_id, :integer
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :fuel_id))
    	add_column :animal_transports, :fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :same_vehicle))
    	add_column :animal_transports, :same_vehicle, :boolean
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :loading))
    	add_column :animal_transports, :loading, :integer
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :carcass))
    	add_column :animal_transports, :carcass, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :boneless_beef))
    	add_column :animal_transports, :boneless_beef, :float
    end
  end
end

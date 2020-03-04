class RenameIdsInAnimalTransport < ActiveRecord::Migration[5.2]
  def change
  	if (ActiveRecord::Base.connection.column_exists?(:animal_transports, :trailer))
  		rename_column :animal_transports, :trailer, :trailer_id
  	end
  	if (ActiveRecord::Base.connection.column_exists?(:animal_transports, :trucks))
  		rename_column :animal_transports, :trucks, :truck_id
  	end
  	if (ActiveRecord::Base.connection.column_exists?(:animal_transports, :fuel_type))
  		rename_column :animal_transports, :fuel_type, :fuel_id
  	end
  end
end

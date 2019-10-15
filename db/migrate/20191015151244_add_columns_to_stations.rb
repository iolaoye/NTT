class AddColumnsToStations < ActiveRecord::Migration
  def change
	if !(ActiveRecord::Base.connection.column_exists?(:stations, :lat))
    	add_column :stations, :lat, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:stations, :lon))
    	add_column :stations, :lon, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:stations, :file_name))
    	add_column :stations, :file_name, :string
    end
    if (ActiveRecord::Base.connection.column_exists?(:stations, :county_id))
    	remove_column :stations, :county_id
    end
    if (ActiveRecord::Base.connection.column_exists?(:stations, :station_name))
    	remove_column :stations, :station_name
    end
    if (ActiveRecord::Base.connection.column_exists?(:stations, :station_code))
    	remove_column :stations, :station_code
    end
    if (ActiveRecord::Base.connection.column_exists?(:stations, :station_type))
    	remove_column :stations, :station_type
    end
    if (ActiveRecord::Base.connection.column_exists?(:stations, :station_status))
    	remove_column :stations, :station_status
    end
    if (ActiveRecord::Base.connection.column_exists?(:stations, :wind_code))
    	remove_column :stations, :wind_code
    end
    if (ActiveRecord::Base.connection.column_exists?(:stations, :wp1_code))
    	remove_column :stations, :wp1_code
    end
    if (ActiveRecord::Base.connection.column_exists?(:stations, :wind_name))
    	remove_column :stations, :wind_name
    end
    if (ActiveRecord::Base.connection.column_exists?(:stations, :wp1_name))
    	remove_column :stations, :wp1_name
    end
    if (ActiveRecord::Base.connection.column_exists?(:stations, :wp1_name))
    	remove_column :stations, :wp1_name
    end
  end
end

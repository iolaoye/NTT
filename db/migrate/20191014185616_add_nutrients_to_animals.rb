class AddNutrientsToAnimals < ActiveRecord::Migration[5.2]
  def change
  	if !(ActiveRecord::Base.connection.column_exists?(:animals, :dry_manure))
    	add_column :animals, :dry_manure, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animals, :no3n))
    	add_column :animals, :no3n, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animals, :po4p))
    	add_column :animals, :po4p, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animals, :orgn))
    	add_column :animals, :orgn, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:animals, :orgp))
    	add_column :animals, :orgp, :float
    end
  end
end

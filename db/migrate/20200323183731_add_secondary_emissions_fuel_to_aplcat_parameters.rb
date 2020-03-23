class AddSecondaryEmissionsFuelToAplcatParameters < ActiveRecord::Migration[5.2]
  def change
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :first_fuel_id))
      add_column :aplcat_parameters, :first_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :second_fuel_id))
      add_column :aplcat_parameters, :second_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :third_fuel_id))
      add_column :aplcat_parameters, :third_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :fourth_fuel_id))
      add_column :aplcat_parameters, :fourth_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :fifth_fuel_id))
      add_column :aplcat_parameters, :fifth_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :sixth_fuel_id))
      add_column :aplcat_parameters, :sixth_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :seventh_fuel_id))
      add_column :aplcat_parameters, :seventh_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :eighth_fuel_id))
      add_column :aplcat_parameters, :eighth_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :ninth_fuel_id))
      add_column :aplcat_parameters, :ninth_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :tenth_fuel_id))
      add_column :aplcat_parameters, :tenth_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :eleventh_fuel_id))
      add_column :aplcat_parameters, :eleventh_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :twelveth_fuel_id))
      add_column :aplcat_parameters, :twelveth_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :thirteen_fuel_id))
      add_column :aplcat_parameters, :thirteen_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :fourteen_fuel_id))
      add_column :aplcat_parameters, :fourteen_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :fifteen_fuel_id))
      add_column :aplcat_parameters, :fifteen_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :sixteen_fuel_id))
      add_column :aplcat_parameters, :sixteen_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :seventeen_fuel_id))
      add_column :aplcat_parameters, :seventeen_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :eighteen_fuel_id))
      add_column :aplcat_parameters, :eighteen_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :ninteen_fuel_id))
      add_column :aplcat_parameters, :ninteen_fuel_id, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:aplcat_parameters, :twenty_fuel_id))
      add_column :aplcat_parameters, :twenty_fuel_id, :string
    end
  end
end

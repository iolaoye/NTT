class AddSoilTestToFields < ActiveRecord::Migration[5.2]
  def change
    if !(ActiveRecord::Base.connection.column_exists?(:fields, :soil_test))
    	add_column :fields, :soil_test, :integer
    end
  end
end

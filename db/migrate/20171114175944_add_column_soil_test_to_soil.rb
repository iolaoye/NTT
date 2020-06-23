class AddColumnSoilTestToSoil < ActiveRecord::Migration[5.2]
  def change
    add_column :soils, :soil_test, :integer
  end
end

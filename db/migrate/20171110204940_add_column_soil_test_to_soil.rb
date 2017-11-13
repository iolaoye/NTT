class AddColumnSoilTestToSoil < ActiveRecord::Migration
  def change
    add_column :soils, :soil_test, :integer
  end
end

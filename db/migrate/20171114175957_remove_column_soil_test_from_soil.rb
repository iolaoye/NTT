class RemoveColumnSoilTestFromSoil < ActiveRecord::Migration
  def change
    remove_column :soils, :soil_test, :integer
  end
end

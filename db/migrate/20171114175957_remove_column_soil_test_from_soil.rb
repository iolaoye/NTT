class RemoveColumnSoilTestFromSoil < ActiveRecord::Migration[5.2]
  def change
    remove_column :soils, :soil_test, :integer
  end
end

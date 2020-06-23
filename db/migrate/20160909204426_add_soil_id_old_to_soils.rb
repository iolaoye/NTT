class AddSoilIdOldToSoils < ActiveRecord::Migration[5.2]
  def change
    add_column :soils, :soil_id_old, :integer
  end
end

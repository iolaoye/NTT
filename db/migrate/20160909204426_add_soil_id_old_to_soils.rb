class AddSoilIdOldToSoils < ActiveRecord::Migration
  def change
    add_column :soils, :soil_id_old, :integer
  end
end

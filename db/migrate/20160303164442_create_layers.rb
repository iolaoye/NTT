class CreateLayers < ActiveRecord::Migration
  def change
    create_table :layers do |t|
      t.float :depth
      t.float :soil_p
      t.float :bulk_density
      t.float :sand
      t.float :silt
      t.float :clay
      t.float :organic_matter
      t.float :ph
      t.integer :soil_id

      t.timestamps
    end
  end
end

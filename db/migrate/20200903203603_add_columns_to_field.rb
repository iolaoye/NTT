class AddColumnsToField < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :depth, :float
    add_column :fields, :tile_bioreactors, :boolean
    add_column :fields, :drainage_water_management, :boolean
  end
end

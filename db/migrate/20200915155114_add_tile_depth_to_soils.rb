class AddTileDepthToSoils < ActiveRecord::Migration[5.2]
  def change
    add_column :soils, :tile_depth, :float
  end
end

class CreateTiledrains < ActiveRecord::Migration[5.2]
  def change
    create_table :tiledrains do |t|
      t.integer :field_id
      t.float :depth
      t.boolean :tb   # Tile Bioreactors
      t.boolean :dwm  # Drainage Water Management

      t.timestamps
    end
  end
end



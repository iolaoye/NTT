class ChangeCoordinatesFormatInLocation < ActiveRecord::Migration[5.2]
  def change
    change_column :locations, :coordinates, :text
  end
end

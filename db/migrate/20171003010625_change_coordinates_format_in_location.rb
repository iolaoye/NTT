class ChangeCoordinatesFormatInLocation < ActiveRecord::Migration
  def change
    change_column :locations, :coordinates, :text
  end
end

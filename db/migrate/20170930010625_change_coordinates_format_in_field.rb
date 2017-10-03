class ChangeCoordinatesFormatInField < ActiveRecord::Migration
  def change
    change_column :fields, :coordinates, :text 
    change_column :locations, :coordinates, :text 
  end
end

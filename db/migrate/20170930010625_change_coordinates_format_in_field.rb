class ChangeCoordinatesFormatInField < ActiveRecord::Migration
  def change
    change_column :fields, :coordinates, :text 
  end
end

class ChangeCoordinatesFormatInField < ActiveRecord::Migration[5.2]
  def change
    change_column :fields, :coordinates, :text
  end
end

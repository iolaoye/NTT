class ChangeFieldsColumnCoordinates < ActiveRecord::Migration[5.2]
  def change
  	change_column :fields, :coordinates, :text, :limit => 16.megabytes - 1  
  end
end

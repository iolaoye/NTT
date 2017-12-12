class ChangeFieldsColumnCoordinates < ActiveRecord::Migration
  def change
  	change_column :fields, :coordinates, :limit => 16.megabytes - 1  
  end
end

class ChangeFieldsColumnCoordinates < ActiveRecord::Migration
  def change
  	change_column :fields, :coordinates, :text, :limit => 16.megabytes - 1  
  end
end

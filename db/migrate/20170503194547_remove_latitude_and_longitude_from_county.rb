class RemoveLatitudeAndLongitudeFromCounty < ActiveRecord::Migration[5.2]
  def up
	remove_column :counties, :latitude
	remove_column :counties, :longitude
  end
  
end

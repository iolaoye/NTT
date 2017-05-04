class RemoveLatitudeAndLongitudeFromCounty < ActiveRecord::Migration
  def up
	remove_column :counties, :latitude
	remove_column :counties, :longitude
  end
  
end

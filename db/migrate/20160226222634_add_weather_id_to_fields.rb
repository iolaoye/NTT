class AddWeatherIdToFields < ActiveRecord::Migration
  def change
    add_column :fields, :weather_id, :integer
	remove_column :fields, :weather_file
  end
end

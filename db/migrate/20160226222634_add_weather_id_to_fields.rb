class AddWeatherIdToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :weather_id, :integer
	remove_column :fields, :weather_file
  end
end

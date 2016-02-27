class AddWeatherFileToFields < ActiveRecord::Migration
  def change
    add_column :fields, :weather_file, :string
  end
end

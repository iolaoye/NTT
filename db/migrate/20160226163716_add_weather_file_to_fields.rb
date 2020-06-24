class AddWeatherFileToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :weather_file, :string
  end
end

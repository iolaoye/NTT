class AddWeatherFileToWeathers < ActiveRecord::Migration
  def change
    add_column :weathers, :weather_file, :string
  end
end

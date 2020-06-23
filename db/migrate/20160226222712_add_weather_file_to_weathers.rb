class AddWeatherFileToWeathers < ActiveRecord::Migration[5.2]
  def change
    add_column :weathers, :weather_file, :string
  end
end

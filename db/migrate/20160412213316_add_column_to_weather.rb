class AddColumnToWeather < ActiveRecord::Migration
  def change
    add_column :weathers, :weather_initial_year, :integer
    add_column :weathers, :weather_final_year, :integer
  end
end

class AddColumnWayIdToWeather < ActiveRecord::Migration[5.2]
  def change
    add_column :weathers, :way_id, :integer
  end
end

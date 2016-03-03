class AddColumnWayIdToWeather < ActiveRecord::Migration
  def change
    add_column :weathers, :way_id, :integer
  end
end

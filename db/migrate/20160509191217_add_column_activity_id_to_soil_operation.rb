class AddColumnActivityIdToSoilOperation < ActiveRecord::Migration
  def change
    add_column :soil_operations, :activity_id, :integer
  end
end

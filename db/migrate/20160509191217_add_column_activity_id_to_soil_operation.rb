class AddColumnActivityIdToSoilOperation < ActiveRecord::Migration[5.2]
  def change
    add_column :soil_operations, :activity_id, :integer
  end
end

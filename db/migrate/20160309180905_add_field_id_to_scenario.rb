class AddFieldIdToScenario < ActiveRecord::Migration[5.2]
  def change
    add_column :scenarios, :field_id, :integer
  end
end

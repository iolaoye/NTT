class AddFieldIdToScenario < ActiveRecord::Migration
  def change
    add_column :scenarios, :field_id, :integer
  end
end

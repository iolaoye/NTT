class AddScenarioIdToOperations < ActiveRecord::Migration[5.2]
  def change
    add_column :operations, :scenario_id, :integer
  end
end

class AddScenarioIdToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :scenario_id, :integer
  end
end

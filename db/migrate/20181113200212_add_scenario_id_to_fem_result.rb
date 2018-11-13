class AddScenarioIdToFemResult < ActiveRecord::Migration
  def change
    add_column :fem_results, :scenario_id, :integer
  end
end

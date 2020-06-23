class AddScenarioIdToFemResult < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_results, :scenario_id, :integer
  end
end

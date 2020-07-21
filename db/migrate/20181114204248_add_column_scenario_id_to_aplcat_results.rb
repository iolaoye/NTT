class AddColumnScenarioIdToAplcatResults < ActiveRecord::Migration[5.2]
  def change
    add_column :aplcat_results, :scenario_id, :integer
  end
end

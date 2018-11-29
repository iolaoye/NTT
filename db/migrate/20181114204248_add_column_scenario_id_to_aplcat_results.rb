class AddColumnScenarioIdToAplcatResults < ActiveRecord::Migration
  def change
    add_column :aplcat_results, :scenario_id, :integer
  end
end

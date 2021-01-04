class AddScenarioIdToCountyResults < ActiveRecord::Migration[5.2]
  def change
  	if !ActiveRecord::Base.connection.column_exists?(:county_results, :scenario_id)
    	add_column :county_results, :scenario_id, :integer
	end
  end
end

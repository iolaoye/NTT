class AddScenarioIdToAnimalTransport < ActiveRecord::Migration[5.2]
  def change
  	if !(ActiveRecord::Base.connection.column_exists?(:animal_transports, :scenario_id))
    	add_column :animal_transports, :scenario_id, :integer
    end
  end
end

class AddSimulationStatusToScenarios < ActiveRecord::Migration[5.2]
  def change
    add_column :scenarios, :simulation_status, :boolean
  end
end

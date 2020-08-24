class AddFemSimulationColumnToScenarios < ActiveRecord::Migration[5.2]
  def change
    add_column :scenarios, :fem_last_simulation, :datetime
  end
end

class AddAplcatSimulationColumnToScenarios < ActiveRecord::Migration[5.2]
  def change
    add_column :scenarios, :aplcat_last_simulation, :datetime
  end
end

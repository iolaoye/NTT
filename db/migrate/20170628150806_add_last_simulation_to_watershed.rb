class AddLastSimulationToWatershed < ActiveRecord::Migration[5.2]
  def change
    add_column :watersheds, :last_simulation, :datetime
  end
end

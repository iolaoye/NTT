class AddLastSimulationToWatershed < ActiveRecord::Migration
  def change
    add_column :watersheds, :last_simulation, :datetime
  end
end

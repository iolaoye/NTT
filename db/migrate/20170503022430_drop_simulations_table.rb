class DropSimulationsTable < ActiveRecord::Migration[5.2]
  def up
	drop_table :simulations
  end
end

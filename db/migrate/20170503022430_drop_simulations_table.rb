class DropSimulationsTable < ActiveRecord::Migration
  def up
	drop_table :simulations
  end
end

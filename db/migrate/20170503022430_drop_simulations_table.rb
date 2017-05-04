class DropSimulationsTable < ActiveRecord::Migration
  def up
	drop_table :Simulations
  end
end

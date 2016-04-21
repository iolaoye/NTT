class DropTableFertilizer < ActiveRecord::Migration
  def change
	drop_table :fertilizers
  end
end

class DropSubareasTable < ActiveRecord::Migration
  def up
	drop_table :subareas
  end

  def down
  end
end

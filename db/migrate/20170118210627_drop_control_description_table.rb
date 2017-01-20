class DropControlDescriptionTable < ActiveRecord::Migration
  def up
	drop_table :control_descriptions
  end
  def down
  end
end

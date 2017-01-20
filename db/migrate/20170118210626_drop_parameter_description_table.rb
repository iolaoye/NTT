class DropParameterDescriptionTable < ActiveRecord::Migration
  def up
	drop_table :parameter_descriptions
  end
  def down
  end
end

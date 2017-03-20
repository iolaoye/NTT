class DropAplcatParametersTable < ActiveRecord::Migration
  def up
	drop_table :aplcat_parameters
  end
end

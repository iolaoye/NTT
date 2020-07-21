class DropAplcatParametersTable < ActiveRecord::Migration[5.2]
  def up
	drop_table :aplcat_parameters
  end
end

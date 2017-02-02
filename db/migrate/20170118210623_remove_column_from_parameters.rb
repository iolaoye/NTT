class RemoveColumnFromParameters < ActiveRecord::Migration
  def up
    remove_column :parameters, :line
    remove_column :parameters, :number
    remove_column :parameters, :name
    remove_column :parameters, :description
    remove_column :parameters, :range_low
    remove_column :parameters, :range_high
  end
end

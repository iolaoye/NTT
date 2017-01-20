class RemoveColumnFromControls < ActiveRecord::Migration
  def up
    remove_column :controls, :line
    remove_column :controls, :column
    remove_column :controls, :code
    remove_column :controls, :name
    remove_column :controls, :description
    remove_column :controls, :range_low
    remove_column :controls, :range_high
  end
end

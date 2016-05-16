class AddColumnToControl < ActiveRecord::Migration
  def change
    add_column :controls, :line, :integer
    add_column :controls, :column, :integer
    add_column :controls, :code, :string
    add_column :controls, :name, :string
    add_column :controls, :description, :string
    add_column :controls, :range_low, :float
    add_column :controls, :range_high, :float
    add_column :controls, :default_value, :float
  end
end

class AddColumnToParameters < ActiveRecord::Migration
  def change
    add_column :parameters, :line, :integer
    add_column :parameters, :number, :integer
    add_column :parameters, :name, :string
    add_column :parameters, :description, :string
    add_column :parameters, :range_low, :float
    add_column :parameters, :range_high, :float
    add_column :parameters, :default_value, :float
  end
end

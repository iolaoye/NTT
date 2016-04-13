class AddColumunToWay < ActiveRecord::Migration
  def change
    add_column :ways, :way_value, :string
  end
end

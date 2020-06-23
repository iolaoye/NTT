class AddColumunToWay < ActiveRecord::Migration[5.2]
  def change
    add_column :ways, :way_value, :string
  end
end

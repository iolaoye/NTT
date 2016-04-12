class AddColumnToWay < ActiveRecord::Migration
  def change
    add_column :ways, :spanish_name, :string
  end
end

class AddColumnToWay < ActiveRecord::Migration[5.2]
  def change
    add_column :ways, :spanish_name, :string
  end
end

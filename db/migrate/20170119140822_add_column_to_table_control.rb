class AddColumnToTableControl < ActiveRecord::Migration
  def change
    add_column :controls, :number, :integer
  end
end

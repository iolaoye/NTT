class AddColumnToTableControl < ActiveRecord::Migration[5.2]
  def change
    add_column :controls, :number, :integer
  end
end

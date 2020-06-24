class AddColumnToTableParameter < ActiveRecord::Migration[5.2]
  def change
    add_column :parameters, :number, :integer
  end
end

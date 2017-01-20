class AddColumnToTableParameter < ActiveRecord::Migration
  def change
    add_column :parameters, :number, :integer
  end
end

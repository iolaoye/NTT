class AddColumnToClimates < ActiveRecord::Migration[5.2]
  def change
    add_column :climates, :month, :integer
  end
end

class AddColumnToClimates < ActiveRecord::Migration
  def change
    add_column :climates, :month, :integer
  end
end

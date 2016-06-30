class RemoveColumnFromClimates < ActiveRecord::Migration
  def up
    remove_column :climates, :month
    remove_column :climates, :spanish_month
  end
end

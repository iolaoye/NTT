class RemoveColumnFromClimates < ActiveRecord::Migration[5.2]
  def up
    remove_column :climates, :month
    remove_column :climates, :spanish_month
  end
end

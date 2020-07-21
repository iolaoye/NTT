class AddColumnPeriodToDescription < ActiveRecord::Migration[5.2]
  def change
    add_column :descriptions, :period, :integer
  end
end

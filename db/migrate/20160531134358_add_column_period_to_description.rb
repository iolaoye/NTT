class AddColumnPeriodToDescription < ActiveRecord::Migration
  def change
    add_column :descriptions, :period, :integer
  end
end

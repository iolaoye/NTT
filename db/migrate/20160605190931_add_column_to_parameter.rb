class AddColumnToParameter < ActiveRecord::Migration
  def change
    add_column :parameters, :state_id, :integer
  end
end

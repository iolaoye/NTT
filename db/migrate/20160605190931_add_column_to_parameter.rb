class AddColumnToParameter < ActiveRecord::Migration[5.2]
  def change
    add_column :parameters, :state_id, :integer
  end
end

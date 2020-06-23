class AddColumnToControls < ActiveRecord::Migration[5.2]
  def change
    add_column :controls, :state_id, :integer
  end
end

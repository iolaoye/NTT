class AddColumnToControls < ActiveRecord::Migration
  def change
    add_column :controls, :state_id, :integer
  end
end

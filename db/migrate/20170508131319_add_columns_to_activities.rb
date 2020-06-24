class AddColumnsToActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :amount_label, :string
    add_column :activities, :amount_units, :string
    add_column :activities, :depth_label, :string
    add_column :activities, :depth_units, :string
  end
end

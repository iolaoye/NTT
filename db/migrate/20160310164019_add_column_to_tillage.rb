class AddColumnToTillage < ActiveRecord::Migration[5.2]
  def change
    add_column :tillages, :activity_id, :integer
  end
end

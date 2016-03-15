class AddColumnToTillage < ActiveRecord::Migration
  def change
    add_column :tillages, :activity_id, :integer
  end
end

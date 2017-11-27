class AddGroupIdToDescriptions < ActiveRecord::Migration
  def change
  	add_column :descriptions, :group_id, :integer
  end
end

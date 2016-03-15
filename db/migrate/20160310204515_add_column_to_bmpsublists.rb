class AddColumnToBmpsublists < ActiveRecord::Migration
  def change
    add_column :bmpsublists, :bmplist_id, :integer
  end
end

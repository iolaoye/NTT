class AddColumnToBmpsublists < ActiveRecord::Migration[5.2]
  def change
    add_column :bmpsublists, :bmplist_id, :integer
  end
end

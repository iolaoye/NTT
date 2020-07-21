class AddBmpsublistColumnToBmps < ActiveRecord::Migration[5.2]
  def change
    add_column :bmps, :bmpsublist_id, :integer
  end
end

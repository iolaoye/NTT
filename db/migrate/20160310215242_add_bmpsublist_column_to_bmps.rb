class AddBmpsublistColumnToBmps < ActiveRecord::Migration
  def change
    add_column :bmps, :bmpsublist_id, :integer
  end
end

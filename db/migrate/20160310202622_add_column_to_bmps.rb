class AddColumnToBmps < ActiveRecord::Migration
  def change
    add_column :bmps, :name, :string
  end
end

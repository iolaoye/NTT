class AddColumnToBmps < ActiveRecord::Migration[5.2]
  def change
    add_column :bmps, :name, :string
  end
end

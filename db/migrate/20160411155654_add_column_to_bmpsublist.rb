class AddColumnToBmpsublist < ActiveRecord::Migration[5.2]
  def change
    add_column :bmpsublists, :spanish_name, :string
  end
end

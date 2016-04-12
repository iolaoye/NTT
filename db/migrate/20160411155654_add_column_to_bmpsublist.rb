class AddColumnToBmpsublist < ActiveRecord::Migration
  def change
    add_column :bmpsublists, :spanish_name, :string
  end
end

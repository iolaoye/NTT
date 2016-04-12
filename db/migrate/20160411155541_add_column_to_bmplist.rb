class AddColumnToBmplist < ActiveRecord::Migration
  def change
    add_column :bmplists, :spanish_name, :string
  end
end

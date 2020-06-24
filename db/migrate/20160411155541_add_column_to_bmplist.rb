class AddColumnToBmplist < ActiveRecord::Migration[5.2]
  def change
    add_column :bmplists, :spanish_name, :string
  end
end

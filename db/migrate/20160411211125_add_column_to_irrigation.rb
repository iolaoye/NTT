class AddColumnToIrrigation < ActiveRecord::Migration[5.2]
  def change
    add_column :irrigations, :spanish_name, :string
  end
end

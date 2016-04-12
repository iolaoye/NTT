class AddColumnToIrrigation < ActiveRecord::Migration
  def change
    add_column :irrigations, :spanish_name, :string
  end
end

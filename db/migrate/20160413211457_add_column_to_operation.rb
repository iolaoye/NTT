class AddColumnToOperation < ActiveRecord::Migration
  def change
    add_column :operations, :subtype_id, :integer
  end
end

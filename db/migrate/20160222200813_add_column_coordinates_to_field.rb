class AddColumnCoordinatesToField < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :coordinates, :string
  end
end

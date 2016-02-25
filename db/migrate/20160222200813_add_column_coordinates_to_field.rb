class AddColumnCoordinatesToField < ActiveRecord::Migration
  def change
    add_column :fields, :coordinates, :string
  end
end

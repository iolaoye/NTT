class AddCoordinatesToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :coordinates, :string
  end
end

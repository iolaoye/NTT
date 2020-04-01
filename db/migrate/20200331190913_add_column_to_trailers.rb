class AddColumnToTrailers < ActiveRecord::Migration[5.2]
  def change
    add_column :trailers, :height, :string
  end
end

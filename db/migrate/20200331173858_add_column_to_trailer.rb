class AddColumnToTrailer < ActiveRecord::Migration[5.2]
  def change
    add_column :trailers, :length, :string
    add_column :trailers, :width, :string
    add_column :trailers, :payload, :string
    add_column :trailers, :suggestion, :string
  end
end

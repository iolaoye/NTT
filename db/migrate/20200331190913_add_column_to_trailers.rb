class AddColumnToTrailers < ActiveRecord::Migration[5.2]
  def change
    if !(ActiveRecord::Base.connection.column_exists?(:trailers, :height))
    	add_column :trailers, :height, :string
    end
  end
end

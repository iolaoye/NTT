class AddColumnToTrailer < ActiveRecord::Migration[5.2]
  def change
    if !(ActiveRecord::Base.connection.column_exists?(:trailers, :length))
    	add_column :trailers, :length, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:trailers, :width))
    	add_column :trailers, :width, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:trailers, :payload))
    	add_column :trailers, :payload, :string
    end
    if !(ActiveRecord::Base.connection.column_exists?(:trailers, :suggestion))
    	add_column :trailers, :suggestion, :string
    end
  end
end

class AddColumnToSubarea < ActiveRecord::Migration[5.2]
  def change
    if !(ActiveRecord::Base.connection.column_exists?(:subareas, :tdms))
	    add_column :subareas, :tdms, :integer
    end
  end
end

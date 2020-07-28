class AddFemColumnToTillages < ActiveRecord::Migration[5.2]
  def change
    if !(ActiveRecord::Base.connection.column_exists?(:tillages, :fem))
    	add_column :tillages, :fem, :integer
    end
  end
  
end

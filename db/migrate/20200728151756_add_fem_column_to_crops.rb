class AddFemColumnToCrops < ActiveRecord::Migration[5.2]
  def change
    if !(ActiveRecord::Base.connection.column_exists?(:crops, :fem))
    	add_column :crops, :fem, :integer
    end
  end
end

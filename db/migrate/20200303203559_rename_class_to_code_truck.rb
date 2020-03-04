class RenameClassToCodeTruck < ActiveRecord::Migration[5.2]
  def change
  	if (ActiveRecord::Base.connection.column_exists?(:trucks, :class))
  		rename_column :trucks, :class, :code
  	end
  end
end

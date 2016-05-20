class DeleteColumnPositionFromResult < ActiveRecord::Migration
	def change
		remove_column :results, :position
		remove_column :results, :description
		remove_column :results, :spanish_description
		remove_column :results, :detailed
		remove_column :results, :units
	end

end

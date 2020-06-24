class AddColumnPositionToResults < ActiveRecord::Migration[5.2]
  def change
	add_column :results, :position, :integer
  end
end

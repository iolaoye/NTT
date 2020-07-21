class RenameActivityColumnOperationId < ActiveRecord::Migration[5.2]
  def change
	rename_column :operations, :operation_id, :activity_id
  end
end

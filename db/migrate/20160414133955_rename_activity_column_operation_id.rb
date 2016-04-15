class RenameActivityColumnOperationId < ActiveRecord::Migration
  def change
	rename_column :operations, :operation_id, :activity_id
  end
end

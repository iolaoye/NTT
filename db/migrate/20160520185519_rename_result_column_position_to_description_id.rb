class RenameResultColumnPositionToDescriptionId < ActiveRecord::Migration
  def change
  	rename_column :results, :position, :description_id
  end
end

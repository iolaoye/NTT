class RenameResultColumnPositionToDescriptionId < ActiveRecord::Migration[5.2]
  def change
  	rename_column :results, :position, :description_id
  end
end

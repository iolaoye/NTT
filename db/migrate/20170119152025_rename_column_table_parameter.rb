class RenameColumnTableParameter < ActiveRecord::Migration[5.2]
  def change
     rename_column :apex_parameters, :parameter_id, :parameter_description_id
  end
end

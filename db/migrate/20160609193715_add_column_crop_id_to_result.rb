class AddColumnCropIdToResult < ActiveRecord::Migration[5.2]
  def change
    add_column :results, :crop_id, :integer
  end
end

class AddColumnCropIdToResult < ActiveRecord::Migration
  def change
    add_column :results, :crop_id, :integer
  end
end

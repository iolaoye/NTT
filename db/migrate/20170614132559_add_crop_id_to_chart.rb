class AddCropIdToChart < ActiveRecord::Migration[5.2]
  def change
    add_column :charts, :crop_id, :integer
  end
end

class AddCropIdToChart < ActiveRecord::Migration
  def change
    add_column :charts, :crop_id, :integer
  end
end

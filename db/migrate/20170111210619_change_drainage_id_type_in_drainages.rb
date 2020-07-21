class ChangeDrainageIdTypeInDrainages < ActiveRecord::Migration[5.2]
  def change
    change_column :soils, :drainage_id, :integer
  end
end

class ChangeDrainageIdTypeInDrainages < ActiveRecord::Migration
  def change
    change_column :soils, :drainage_id, :integer
  end
end

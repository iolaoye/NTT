class RenameDrainageTypeToDrainageId < ActiveRecord::Migration[5.2]
  def change
    rename_column :soils, :drainage_type, :drainage_id
  end
end

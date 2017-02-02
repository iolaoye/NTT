class RenameDrainageTypeToDrainageId < ActiveRecord::Migration
  def change
    rename_column :soils, :drainage_type, :drainage_id
  end
end

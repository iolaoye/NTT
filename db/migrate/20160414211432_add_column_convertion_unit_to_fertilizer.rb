class AddColumnConvertionUnitToFertilizer < ActiveRecord::Migration
  def change
    add_column :fertilizers, :convertion_unit, :float
  end
end

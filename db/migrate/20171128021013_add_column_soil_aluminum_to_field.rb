class AddColumnSoilAluminumToField < ActiveRecord::Migration
  def change
    add_column :fields, :soil_aliminum, :float
  end
end

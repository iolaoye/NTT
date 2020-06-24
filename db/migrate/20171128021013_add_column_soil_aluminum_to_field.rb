class AddColumnSoilAluminumToField < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :soil_aliminum, :float
  end
end

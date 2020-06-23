class AddSoilpToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :soilp, :float
  end
end

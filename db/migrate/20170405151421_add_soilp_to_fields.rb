class AddSoilpToFields < ActiveRecord::Migration
  def change
    add_column :fields, :soilp, :float
  end
end

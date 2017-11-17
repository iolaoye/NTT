class AddColumnsToFertilizers < ActiveRecord::Migration
  def change
    add_column :fertilizers, :total_n, :float
    add_column :fertilizers, :total_p, :float
  end
end

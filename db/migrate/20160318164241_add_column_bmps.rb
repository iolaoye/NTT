class AddColumnBmps < ActiveRecord::Migration
  def change
    add_column :bmps, :difference_max_temperature, :float
    add_column :bmps, :difference_min_temperature, :float
    add_column :bmps, :difference_precipitation, :float
  end
end

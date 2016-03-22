class AddColumnsToSoil < ActiveRecord::Migration
  def change
    add_column :soils, :ffc, :float
    add_column :soils, :wtmn, :float
    add_column :soils, :wtmx, :float
    add_column :soils, :wtbl, :float
    add_column :soils, :gwst, :float
    add_column :soils, :gwmx, :float
    add_column :soils, :rft, :float
    add_column :soils, :rfpk, :float
    add_column :soils, :tsla, :float
    add_column :soils, :xids, :float
    add_column :soils, :rtn1, :float
    add_column :soils, :xidk, :float
    add_column :soils, :zqt, :float
    add_column :soils, :zf, :float
    add_column :soils, :ztk, :float
    add_column :soils, :fbm, :float
    add_column :soils, :fhp, :float
  end
end

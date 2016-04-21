class AddColumnsToLayer < ActiveRecord::Migration
  def change
    add_column :layers, :uw, :float
    add_column :layers, :fc, :float
    add_column :layers, :wn, :float
    add_column :layers, :smb, :float
    add_column :layers, :woc, :float
    add_column :layers, :cac, :float
    add_column :layers, :cec, :float
    add_column :layers, :rok, :float
    add_column :layers, :cnds, :float
    add_column :layers, :rsd, :float
    add_column :layers, :bdd, :float
    add_column :layers, :psp, :float
    add_column :layers, :satc, :float
  end
end

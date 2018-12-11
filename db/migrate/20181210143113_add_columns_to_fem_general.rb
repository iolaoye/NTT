class AddColumnsToFemGeneral < ActiveRecord::Migration
  def change
    add_column :fem_generals, :codes, :integer
    add_column :fem_generals, :ownership, :integer
  end
end

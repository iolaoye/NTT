class AddColumnsToFemGeneral < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_generals, :codes, :integer
    add_column :fem_generals, :ownership, :integer
  end
end

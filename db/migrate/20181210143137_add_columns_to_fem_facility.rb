class AddColumnsToFemFacility < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_facilities, :codes, :integer
    add_column :fem_facilities, :ownership, :integer
  end
end

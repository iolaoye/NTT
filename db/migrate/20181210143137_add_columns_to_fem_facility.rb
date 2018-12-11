class AddColumnsToFemFacility < ActiveRecord::Migration
  def change
    add_column :fem_facilities, :codes, :integer
    add_column :fem_facilities, :ownership, :integer
  end
end

class AddUnitColumnToFemFacility < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_facilities, :unit, :string
  end
end

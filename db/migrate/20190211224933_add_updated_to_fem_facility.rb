class AddUpdatedToFemFacility < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_facilities, :updated, :boolean
  end
end

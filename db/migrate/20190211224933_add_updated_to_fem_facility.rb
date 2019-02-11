class AddUpdatedToFemFacility < ActiveRecord::Migration
  def change
    add_column :fem_facilities, :updated, :boolean
  end
end

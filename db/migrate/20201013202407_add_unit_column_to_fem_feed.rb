class AddUnitColumnToFemFeed < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_feeds, :unit, :string
  end
end

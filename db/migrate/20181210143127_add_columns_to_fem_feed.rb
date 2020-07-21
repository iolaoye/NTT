class AddColumnsToFemFeed < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_feeds, :codes, :integer
    add_column :fem_feeds, :ownership, :integer
  end
end

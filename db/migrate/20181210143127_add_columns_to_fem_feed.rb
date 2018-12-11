class AddColumnsToFemFeed < ActiveRecord::Migration
  def change
    add_column :fem_feeds, :codes, :integer
    add_column :fem_feeds, :ownership, :integer
  end
end

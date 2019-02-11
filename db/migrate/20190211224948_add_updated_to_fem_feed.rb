class AddUpdatedToFemFeed < ActiveRecord::Migration
  def change
    add_column :fem_feeds, :updated, :boolean
  end
end

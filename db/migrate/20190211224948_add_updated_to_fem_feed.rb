class AddUpdatedToFemFeed < ActiveRecord::Migration[5.2]
  def change
    add_column :fem_feeds, :updated, :boolean
  end
end

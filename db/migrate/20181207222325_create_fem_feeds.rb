class CreateFemFeeds < ActiveRecord::Migration
  def change
    create_table :fem_feeds do |t|
      t.string :name
      t.float :selling_price
      t.float :purchase_price
      t.float :concentrate
      t.float :forage
      t.float :grain
      t.float :hay
      t.float :pasture
      t.float :silage
      t.float :supplement

      t.timestamps null: false
    end
  end
end

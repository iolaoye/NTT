class CreateFeedsAugmenteds < ActiveRecord::Migration[5.2]
  def change
    create_table :feeds_augmenteds do |t|
      t.string :name
      t.float :selling_price
      t.float :purchase_price
      t.integer :concentrate
      t.integer :forage
      t.integer :grain
      t.integer :hay
      t.integer :pasture
      t.integer :silage
      t.integer :supplement

      t.timestamps null: false
    end
  end
end

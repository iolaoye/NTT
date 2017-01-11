class CreateDrainages < ActiveRecord::Migration
  def change
    create_table :drainages do |t|
      t.integer :id
      t.string :name
      t.integer :wtmx
      t.integer :wtmn
      t.integer :wtbl
      t.integer :zqt
      t.integer :ztk

      t.timestamps
    end
  end
end

class CreateDrainages < ActiveRecord::Migration[5.2]
  def change
    create_table :drainages do |t|
      t.integer :drainage_id
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

class CreateCropResults < ActiveRecord::Migration
  def change
    create_table :crop_results do |t|
      t.integer :scenario_id
      t.string :name
      t.integer :sub1
      t.integer :year
      t.float :yldg
      t.float :yldf
      t.float :ws
      t.float :ns
      t.float :ps
      t.float :ts

      t.timestamps null: false
    end
  end
end

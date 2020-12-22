class CreateCountyCropResults < ActiveRecord::Migration[5.2]
  def change
    create_table :county_crop_results do |t|
      t.integer :state_id
      t.integer :county_id
      t.integer :scenario_id
      t.string :name
      t.float :yield
      t.float :ws
      t.float :ns
      t.float :ps
      t.float :ts
      t.float :yield_ci

      t.timestamps
    end
  end
end

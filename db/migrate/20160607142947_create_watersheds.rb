class CreateWatersheds < ActiveRecord::Migration[5.2]
  def change
    create_table :watersheds do |t|
      t.string :name
      t.integer :field_id
      t.integer :scenario_id

      t.timestamps
    end
  end
end

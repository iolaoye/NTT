class CreateFarmGenerals < ActiveRecord::Migration[5.2]
  def change
    create_table :farm_generals do |t|
      t.string :name
      t.integer :values

      t.timestamps null: false
    end
  end
end

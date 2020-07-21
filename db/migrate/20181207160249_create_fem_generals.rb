class CreateFemGenerals < ActiveRecord::Migration[5.2]
  def change
    create_table :fem_generals do |t|
      t.string :name
      t.float :value

      t.timestamps null: false
    end
  end
end

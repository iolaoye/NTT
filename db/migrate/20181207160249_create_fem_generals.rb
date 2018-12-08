class CreateFemGenerals < ActiveRecord::Migration
  def change
    create_table :fem_generals do |t|
      t.string :name
      t.float :value

      t.timestamps null: false
    end
  end
end

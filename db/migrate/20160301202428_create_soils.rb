class CreateSoils < ActiveRecord::Migration
  def change
    create_table :soils do |t|
      t.boolean :selected
      t.string :key
      t.string :symbol
      t.string :group
      t.string :name
      t.float :albedo
      t.float :slope
      t.float :percentage
      t.integer :field_id
      t.string :drainage_type

      t.timestamps
    end
  end
end

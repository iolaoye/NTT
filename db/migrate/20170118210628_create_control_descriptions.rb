class CreateControlDescriptions < ActiveRecord::Migration
  def change
    create_table :control_descriptions do |t|
      t.integer :id
      t.integer :line
      t.integer :column
      t.string :code
      t.string :name
      t.float :range_low
      t.float :range_high

      t.timestamps
    end
  end
end

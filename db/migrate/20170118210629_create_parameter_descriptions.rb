class CreateParameterDescriptions < ActiveRecord::Migration
  def change
    create_table :parameter_descriptions do |t|
      t.integer :id
      t.integer :line
      t.integer :number
      t.string :name
      t.float :range_low
      t.float :range_high

      t.timestamps
    end
  end
end

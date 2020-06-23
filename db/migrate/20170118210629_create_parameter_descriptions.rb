class CreateParameterDescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :parameter_descriptions do |t|
      t.integer :parameter_desc_id
      t.integer :line
      t.integer :number
      t.string :name
      t.float :range_low
      t.float :range_high

      t.timestamps
    end
  end
end

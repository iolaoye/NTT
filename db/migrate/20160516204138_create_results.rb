class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :watershed_id
      t.integer :field_id
      t.integer :soil_id
      t.integer :scenario_id
      t.boolean :detailed
      t.string :description
      t.string :spanish_description
      t.string :units
      t.float :value
	  t.integer :order

      t.timestamps
    end
  end
end

class CreateSimulations < ActiveRecord::Migration
  def change
    create_table :simulations do |t|
      t.integer :type_id
      t.string :field_id
      t.string :subproject_id
      t.integer :scenario_id
      t.boolean :project
      t.boolean :location
      t.boolean :weather
      t.boolean :fields
      t.boolean :soils
      t.boolean :layers
      t.boolean :management
      t.string :las_simulation
      t.string :comments

      t.timestamps
    end
  end
end

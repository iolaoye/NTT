class CreateFieldsTable < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.integer :location_id
      t.string :field_name
      t.float :field_area
      t.float :field_average_slope
      t.boolean :field_type

      t.timestamps
    end
  end
end

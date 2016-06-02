class CreateCharts < ActiveRecord::Migration
  def change
    create_table :charts do |t|
      t.integer :description_id
	  t.integer :watershed_id
      t.integer :scenario_id
      t.integer :field_id
      t.integer :soil_id
      t.integer :month_year
      t.float :value

      t.timestamps
    end
  end
end

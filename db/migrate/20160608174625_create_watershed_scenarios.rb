class CreateWatershedScenarios < ActiveRecord::Migration
  def change
    create_table :watershed_scenarios do |t|
      t.integer :watershed_id
      t.integer :field_id
      t.integer :scenario_id

      t.timestamps
    end
  end
end

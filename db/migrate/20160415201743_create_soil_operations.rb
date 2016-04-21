class CreateSoilOperations < ActiveRecord::Migration
  def change
    create_table :soil_operations do |t|

      t.timestamps
    end
  end
end

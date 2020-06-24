class CreateSoilOperations < ActiveRecord::Migration[5.2]
  def change
    create_table :soil_operations do |t|

      t.timestamps
    end
  end
end

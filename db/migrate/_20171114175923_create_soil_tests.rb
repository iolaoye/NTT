class CreateSoilTests < ActiveRecord::Migration
  def change
    create_table :soil_tests do |t|
      t.string :name
      t.float :factor1
      t.float :factor2

      t.timestamps null: false
    end
  end
end

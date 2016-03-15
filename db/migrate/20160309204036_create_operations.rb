class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.integer :crop_id
      t.integer :operation_id
      t.integer :day
      t.integer :month_id
      t.integer :year
      t.integer :type_id
      t.float :amount
      t.float :depth
      t.float :no3_n
      t.float :po4_p
      t.float :org_n
      t.float :org_p
      t.float :nh3

      t.timestamps
    end
  end
end

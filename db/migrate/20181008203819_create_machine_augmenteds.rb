class CreateMachineAugmenteds < ActiveRecord::Migration
  def change
    create_table :machine_augmenteds do |t|
      t.string :name
      t.float :lease_rate
      t.float :new_price
      t.integer :new_hours
      t.float :current_price
      t.integer :hours_remaining
      t.float :width
      t.float :speed
      t.float :field_efficiency
      t.float :horse_power
      t.float :rf1
      t.float :rf2
      t.float :ir_loan
      t.float :l_loan
      t.float :ir_equity
      t.float :p_debt
      t.integer :year
      t.float :rv1
      t.float :rv2

      t.timestamps null: false
    end
  end
end

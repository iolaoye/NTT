class CreateFacilityAugmenteds < ActiveRecord::Migration[5.2]
  def change
    create_table :facility_augmenteds do |t|
      t.string :name
      t.float :lease_rate
      t.float :new_price
      t.float :current_price
      t.integer :life_remaining
      t.float :maintenance_coeff
      t.float :loan_interest_rate
      t.float :length_loan
      t.float :interest_rate_equity
      t.float :proportion_debt
      t.integer :year

      t.timestamps null: false
    end
  end
end

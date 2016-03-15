class CreateTillages < ActiveRecord::Migration
  def change
    create_table :tillages do |t|
      t.string :name
      t.integer :code
      t.string :abbreviation
      t.string :spanish_name
      t.integer :operation
      t.integer :dndc
      t.string :eqp
      t.boolean :status

      t.timestamps
    end
  end
end

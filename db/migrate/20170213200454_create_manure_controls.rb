class CreateManureControls < ActiveRecord::Migration
  def change
    create_table :manure_controls do |t|
      t.integer :id
      t.string :name
      t.string :spanish_name
      t.float :no3n
      t.float :po4p
      t.float :orgn
      t.float :orgp
      t.float :om

      t.timestamps
    end
  end
end

class CreateTableFertilizers < ActiveRecord::Migration
  def change
    create_table :fertilizers do |t|
      t.integer :code
      t.string :name
      t.float :qn
      t.float :qp
      t.float :yn
      t.float :yp
      t.float :nh3
      t.float :lbs
      t.integer :type
      t.boolean :status
      t.string :spanish_name

      t.timestamps
    end
  end
end

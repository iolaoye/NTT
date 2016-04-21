class CreateTableFertilizer < ActiveRecord::Migration
  def change
    create_table :fertilizers do |t|
      t.integer :code
      t.string :name
      t.float :qn
      t.float :qp
      t.float :yn
      t.float :yp
      t.float :nh3
      t.float :dry_matter
      t.integer :fertilizer_type_id
	  t.float :convertion_unit
      t.boolean :status
      t.boolean :animal
      t.string :spanish_name

      t.timestamps
    end
 end
end

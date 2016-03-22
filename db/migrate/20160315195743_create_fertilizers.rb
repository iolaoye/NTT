class CreateFertilizers < ActiveRecord::Migration
  def change
    create_table :fertilizers do |t|
      t.string :abbreviation
      t.integer :code
      t.integer :dndc
      t.string :name
      t.integer :operation
      t.string :spinsh_name
      t.boolean :status
      t.integer :activity_id

      t.timestamps
    end
  end
end

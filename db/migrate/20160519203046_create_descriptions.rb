class CreateDescriptions < ActiveRecord::Migration
  def change
    create_table :descriptions do |t|
      t.boolean :detail
      t.string :description
      t.string :spanish_description
      t.string :unit
      t.integer :position

      t.timestamps
    end
  end
end

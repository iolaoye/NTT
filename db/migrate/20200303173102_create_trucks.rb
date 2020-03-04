class CreateTrucks < ActiveRecord::Migration[5.2]
  def change
    create_table :trucks do |t|
      t.string :class
      t.string :description

      t.timestamps
    end
  end
end

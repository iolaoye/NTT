class CreateCroppingSystems < ActiveRecord::Migration
  def change
    create_table :cropping_systems do |t|
      t.string :name
      t.string :crop
      t.string :tillage
      t.string :var12
      t.string :state_id
      t.boolean :grazing
      t.boolean :status

      t.timestamps
    end
  end
end

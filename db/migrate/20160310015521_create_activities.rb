class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.integer :code
      t.string :abbreviation
      t.string :spanish_name
      t.integer :apex_code

      t.timestamps
    end
  end
end

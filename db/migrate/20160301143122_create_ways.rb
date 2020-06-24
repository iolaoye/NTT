class CreateWays < ActiveRecord::Migration[5.2]
  def change
    create_table :ways do |t|
      t.string :way_name

      t.timestamps
    end
  end
end

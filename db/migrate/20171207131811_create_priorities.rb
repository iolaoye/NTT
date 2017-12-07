class DreatePriorities < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.integer :issue_id
      t.string :name

      t.timestamps null: false
  end
end

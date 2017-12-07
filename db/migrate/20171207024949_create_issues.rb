class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :title
      t.text :descritpion
      t.integer :comment_id
      t.date :expected_data
      t.date :close_date
      t.integer :status_id
      t.integer :user_id
      t.integer :class_id

      t.timestamps null: false
    end
  end
end

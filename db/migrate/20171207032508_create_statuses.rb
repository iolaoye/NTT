class CreateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :statuses do |t|
      t.integer :issue_id
      t.string :name

      t.timestamps null: false
    end
  end
end

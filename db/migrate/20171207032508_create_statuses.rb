class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.integer :issue_id
      t.string :name

      t.timestamps null: false
    end
  end
end

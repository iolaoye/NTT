class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :group_name
      t.string :spanish_group_name

      t.timestamps null: false
    end
  end
end

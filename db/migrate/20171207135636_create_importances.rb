class CreateImportances < ActiveRecord::Migration
  def change
    create_table :importances do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end

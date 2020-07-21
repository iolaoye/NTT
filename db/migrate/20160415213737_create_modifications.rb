class CreateModifications < ActiveRecord::Migration[5.2]
  def change
    create_table :modifications do |t|

      t.timestamps
    end
  end
end

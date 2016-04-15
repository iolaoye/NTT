class CreateModifications < ActiveRecord::Migration
  def change
    create_table :modifications do |t|

      t.timestamps
    end
  end
end

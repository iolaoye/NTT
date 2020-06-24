class CreateParameters < ActiveRecord::Migration[5.2]
  def change
    create_table :parameters do |t|

      t.timestamps
    end
  end
end

class CreateSubareaTable < ActiveRecord::Migration
  def change
    create_table :subareas do |t|

      t.timestamps
    end
  end
end

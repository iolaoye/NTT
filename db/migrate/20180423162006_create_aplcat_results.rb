class CreateAplcatResults < ActiveRecord::Migration
  def change
    create_table :aplcat_results do |t|
      t.string :month_id
      t.string :option_id

      t.timestamps null: false
    end
  end
end

class CreateClimates < ActiveRecord::Migration
  def change
    create_table :climates do |t|
      t.integer :bmp_id
      t.string :month
      t.string :spanish_month
      t.float :max_temp
      t.float :min_temp
      t.float :precipitation

      t.timestamps
    end
  end
end

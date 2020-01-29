class CreateClimes < ActiveRecord::Migration[5.2]
  def change
    create_table :climes do |t|
      t.integer :field_id
      t.string :daily_weather
      t.timestamps
    end
  end
end

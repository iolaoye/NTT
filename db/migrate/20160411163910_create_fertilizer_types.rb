class CreateFertilizerTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :fertilizer_types do |t|
      t.string :name
      t.string :spanish_name

      t.timestamps
    end
  end
end

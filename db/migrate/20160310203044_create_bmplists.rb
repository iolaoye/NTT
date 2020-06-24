class CreateBmplists < ActiveRecord::Migration[5.2]
  def change
    create_table :bmplists do |t|
      t.string :name

      t.timestamps
    end
  end
end

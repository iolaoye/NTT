class CreateBmplists < ActiveRecord::Migration
  def change
    create_table :bmplists do |t|
      t.string :name

      t.timestamps
    end
  end
end

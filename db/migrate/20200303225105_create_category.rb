class CreateCategory < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.integer :animal_transport_id
      t.float :weight
      t.integer :animals
    end
  end
end

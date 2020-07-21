class CreateComments < ActiveRecord::Migration[5.2]
  if ActiveRecord::Base.connection.data_source_exists? "comments"
  	drop_table :comments
  end
  def change
    create_table :comments do |t|
      t.string :name
      t.text :body
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end

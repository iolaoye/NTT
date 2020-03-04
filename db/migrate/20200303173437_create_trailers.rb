class CreateTrailers < ActiveRecord::Migration[5.2]
  def change
    create_table :trailers do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
